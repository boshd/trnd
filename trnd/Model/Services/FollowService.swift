//
//  FollowService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETNamesCompletion = ([String]) -> Void
typealias GETFollowingCompletion = (Bool) -> Void
typealias UnfollowCompletion = (() -> Void)?
typealias FollowCompletion = (() -> Void)?
struct FollowService {

    static func getFollowerNamesFor(_ name: String, completion: @escaping GETNamesCompletion) {
        let followQuery = PFQuery(className: ParseClass.Follow)
        followQuery.order(byAscending: QueryKey.CreatedAt)
        followQuery.whereKey(QueryKey.Following, equalTo: name)
        
        ParseOperation.getObjects(forQuery: followQuery) { (objects: [PFObject]) in
            var followerNames = [String]()
            for follower in objects {
                followerNames.append(follower.object(forKey: QueryKey.Follower) as! String)
            }
            completion(followerNames)
        }
    }
    
    static func getFollowingNamesFor(_ name: String, completion: @escaping GETNamesCompletion) {
        let followQuery = PFQuery(className: ParseClass.Follow)
        followQuery.order(byAscending: QueryKey.CreatedAt)
        followQuery.whereKey(QueryKey.Follower, equalTo: name)
        
        ParseOperation.getObjects(forQuery: followQuery) { (objects: [PFObject]) in
            var followingNames = [String]()
            for following in objects {
                followingNames.append(following.object(forKey: QueryKey.Following) as! String)
            }
            completion(followingNames)
        }
    }

    static func getFollowingCount(_ name: String, completion: @escaping GETCountCompletion) {
        let query = PFQuery(className: ParseClass.Follow)
        query.whereKey(QueryKey.Follower, equalTo: name)
        ParseOperation.countObjects(forQuery: query) { (count: Int32) in
            completion(count)
        }
    }
    //check again!!!!
    static func getFollowerCount(_ name: String, completion: @escaping GETCountCompletion) {
        let query = PFQuery(className: ParseClass.Follow)
        query.whereKey(QueryKey.Following, equalTo: name)
        ParseOperation.countObjects(forQuery: query) { (count: Int32) in
            completion(count)
        }
    }

    static func isUserFollowing(_ name: String, completion: @escaping GETFollowingCompletion) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let query = PFQuery(className: ParseClass.Follow)
        query.whereKey(QueryKey.Follower, equalTo: currentUsername)
        query.whereKey(QueryKey.Following, equalTo: name)
        ParseOperation.countObjects(forQuery: query) { (count: Int32) in
            count == 0 ? completion(false) : completion(true)
        }
    }
    
    // Follows a user with a name .... i think?
    static func follow(_ name: String, completion: FollowCompletion = nil) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let object = PFObject(className: ParseClass.Follow)
        object[QueryKey.Follower] = currentUsername
        object[QueryKey.Following] = name
        ParseOperation.saveObject(object: object) { (success: Bool) in
            if success {
                NotificationService.createNotification(NotificationType.Follow, uniqueID: "", forUser: name, notifOwner: name)
                completion?()
            }
        }
    }
    
    static func unfollow(_ name: String, completion: UnfollowCompletion = nil) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let removeQuery = PFQuery(className: ParseClass.Follow)
        removeQuery.whereKey(QueryKey.Follower, equalTo: currentUsername)
        removeQuery.whereKey(QueryKey.Following, equalTo: name)
        
        ParseOperation.getObjects(forQuery: removeQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
            NotificationService.deleteFollowNotification(currentUsername, forUser: name)
            completion?()
        }
    }
}
