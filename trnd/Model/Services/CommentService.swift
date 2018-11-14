//
//  CommentService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETCommentCountCompletion = (Int) -> Void
typealias GETCommentsCompletion = ([String], [PFFile], [String], [Date?]) -> Void
typealias CreateCommentCompletion = (() -> Void)?
typealias DeleteCommentCompletion = (() -> Void)?

struct CommentService {

    static func countComments(withPostID id: String, completion: @escaping GETCommentCountCompletion) {
        let countQuery = PFQuery(className: ParseClass.Comment)
        countQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.countObjects(forQuery: countQuery) { (count: Int32) in
            completion(Int(count))
        }
    }
    
    static func retrieveComments(forPostID id: String, andSkip skip: Int, completion: @escaping GETCommentsCompletion) {
        let commentQuery = PFQuery(className: ParseClass.Comment)
        commentQuery.whereKey(QueryKey.To, equalTo: id)
        commentQuery.addAscendingOrder(QueryKey.CreatedAt)
        commentQuery.skip = skip
        ParseOperation.getObjects(forQuery: commentQuery) { (objects: [PFObject]) in
            var usernames = [String]()
            var avatars = [PFFile]()
            var comments = [String]()
            var dates = [Date?]()
            
            for object in objects {
                usernames.append(object.value(forKey: QueryKey.Username) as! String)
                avatars.append(object.value(forKey: QueryKey.Avatar) as! PFFile)
                comments.append(object.value(forKey: QueryKey.Comment) as! String)
                dates.append(object.value(forKey: QueryKey.CreatedAt) as? Date)
            }
            completion(usernames, avatars, comments, dates)
        }
    }
    
    static func createComment(withPostID id: String, andMessage message: String, commentOwner: String, completion: CreateCommentCompletion = nil) {
        guard let currentUser = PFUser.current() else { return }
        let comment = PFObject(className: ParseClass.Comment)
        comment[QueryKey.To] = id
        comment[QueryKey.Username] = currentUser.username
        comment[QueryKey.Avatar] = currentUser.value(forKey: QueryKey.Avatar) as! PFFile
        comment[QueryKey.Comment] = message
        ParseOperation.saveObject(object: comment) { (success: Bool) in
            if success { completion?() }
        }
        HashtagService.createHashtagIfExists(message, forID: id)
        NotificationService.checkForMention(message, uniqueID: id, notifOwner: commentOwner)
        NotificationService.createNotification(NotificationType.Comment, uniqueID: id, forUser: commentOwner, notifOwner: commentOwner)
    }
    
    static func deleteComment(withPostID id: String, messageToDelete message: String, completion: DeleteCommentCompletion = nil) {
        let deleteQuery = PFQuery(className: ParseClass.Comment)
        deleteQuery.whereKey(QueryKey.To, equalTo: id)
        deleteQuery.whereKey(QueryKey.Comment, equalTo: message)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            objects.forEach { ParseOperation.deleteObject(object: $0) }
            completion?()
        }
    }
    
    static func deleteComment(withPostID id: String) {
        let deleteQuery = PFQuery(className: ParseClass.Comment)
        deleteQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            objects.forEach { ParseOperation.deleteObject(object: $0) }
        }
    }
}
