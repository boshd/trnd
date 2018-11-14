//
//  LikeService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETLikeCount = (Int) -> Void
typealias LikeCompletion = () -> Void
typealias UnlikeCompletion = () -> Void

struct LikeService {
    
    // Checks if the user has already liked a post
    static func userHasLikedPost(withUniqueID id: String, completion: @escaping (Bool) -> Void) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let likeQuery = PFQuery(className: ParseClass.Like)
        likeQuery.whereKey(QueryKey.By, equalTo: currentUsername)
        likeQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.countObjects(forQuery: likeQuery) { (count: Int32) in
            count == 0 ? completion(false) : completion(true)
        }
    }
    
    // Gets the number of likes for a post with a specific unique ID
    static func likeCountForPost(withUniqueID id: String, completion: @escaping GETLikeCount) {
        let countQuery = PFQuery(className: ParseClass.Like)
        countQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.countObjects(forQuery: countQuery) { (count: Int32) in
            completion(Int(count))
        }
    }
    
    // Likes a post with a given unique ID for the current user
    static func likePost(withUniqueID id: String, postOwner: String, completion: @escaping LikeCompletion) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let like = PFObject(className: ParseClass.Like)
        like[QueryKey.By] = currentUsername
        like[QueryKey.To] = id
        ParseOperation.saveObject(object: like) { (success: Bool) in
            if success {
                NotificationService.createNotification(NotificationType.Like, uniqueID: id, forUser: postOwner, notifOwner: postOwner)
                completion()
            }
        }
    }
    
    // Unlikes a post with a given unique ID for the current user
    static func unlikePost(withUniqueID id: String, completion: @escaping UnlikeCompletion) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let unlikeQuery = PFQuery(className: ParseClass.Like)
        unlikeQuery.whereKey(QueryKey.By, equalTo: currentUsername)
        unlikeQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.getObjects(forQuery: unlikeQuery) { (objects: [PFObject]) in
            if let like = objects.first {
                ParseOperation.deleteObject(object: like) { (success: Bool) in
                    if success {
                        NotificationService.deleteLikeNotification(currentUsername, forUniqueID: id)
                        completion()
                    }
                }
            }
        }
    }
}
