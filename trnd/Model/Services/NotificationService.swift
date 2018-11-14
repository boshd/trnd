//
//  NotificationService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETNotificationsCompletion = ([String], [PFFile], [String], [Date], [String], [String]) -> Void

enum NotificationType: String {
    case Mention
    case Follow
    case Comment
    case Like
}

struct NotificationService {
    
    static func retrieveNotifications(withLimit limit: Int, completion: @escaping GETNotificationsCompletion) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let notifQuery = PFQuery(className: ParseClass.Notification)
        notifQuery.limit = limit
        notifQuery.whereKey(QueryKey.To, equalTo: currentUsername)
        notifQuery.whereKey(QueryKey.Checked, equalTo: "no")
        ParseOperation.getObjects(forQuery: notifQuery) { (objects: [PFObject]) in
            
            var usernames = [String]()
            var avatarFiles = [PFFile]()
            var notificationTypes = [String]()
            var dates = [Date]()
            var uniqueIDs = [String]()
            var owners = [String]()
            
            for object in objects {
                usernames.append(object.value(forKey: QueryKey.By) as! String)
                avatarFiles.append(object.value(forKey: QueryKey.Avatar) as! PFFile)
                notificationTypes.append(object.value(forKey: QueryKey.NotifType) as! String)
                dates.append(object.value(forKey: QueryKey.CreatedAt) as! Date)
                uniqueIDs.append(object.value(forKey: QueryKey.UniqueID) as! String)
                owners.append(object.value(forKey: QueryKey.Owner) as! String)
                object[QueryKey.Checked] = "yes"
                ParseOperation.saveObject(object: object)
            }
            completion(usernames, avatarFiles, notificationTypes, dates, uniqueIDs, owners)
        }
    }
    
    static func notificationsUnchecked(_ type: [String], completion: @escaping (Int) -> Void) {
        guard let currentUsername = PFUser.current()?.username else { return }
        let notifQuery = PFQuery(className: ParseClass.Notification)
        notifQuery.whereKey(QueryKey.To, equalTo: currentUsername)
        notifQuery.whereKey(QueryKey.Checked, equalTo: "no")
        notifQuery.whereKey(QueryKey.NotifType, containedIn: type)
        ParseOperation.countObjects(forQuery: notifQuery) { (count: Int32) in
            if count > 0 {
                completion(Int(count))
            }
        }
    }

    static func checkForMention(_ text: String?, uniqueID: String, notifOwner: String) {
        guard let text = text else { return }
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("@") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.symbols)
                NotificationService.createNotification(NotificationType.Mention, uniqueID: uniqueID, forUser: word, notifOwner: notifOwner)
            }
        }
    }
    
    static func createNotification(_ type: NotificationType, uniqueID: String, forUser: String, notifOwner: String) {
        guard let currentUser = PFUser.current() else { return }
        
        if notifOwner != currentUser.username {
            let notification = PFObject(className: ParseClass.Notification)
            notification[QueryKey.By] = currentUser.username
            notification[QueryKey.Avatar] = currentUser.object(forKey: QueryKey.Avatar) as! PFFile
            notification[QueryKey.To] = forUser
            notification[QueryKey.UniqueID] = uniqueID
            notification[QueryKey.NotifType] = type.rawValue
            notification[QueryKey.Owner] = notifOwner
            notification[QueryKey.Checked] = "no"
            ParseOperation.saveObject(object: notification)
        }
    }

    static func deleteNotification(_ by: String, owner: String) {
        let deleteQuery = PFQuery(className: ParseClass.Notification)
        deleteQuery.whereKey(QueryKey.By, equalTo: by)
        deleteQuery.whereKey(QueryKey.To, equalTo: owner)
        deleteQuery.whereKey(QueryKey.NotifType, containedIn: [NotificationType.Comment.rawValue, NotificationType.Mention.rawValue])
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
    
    static func deleteLikeNotification(_ by: String, forUniqueID id: String) {
        let deleteQuery = PFQuery(className: ParseClass.Notification)
        deleteQuery.whereKey(QueryKey.By, equalTo: by)
        deleteQuery.whereKey(QueryKey.UniqueID, equalTo: id)
        deleteQuery.whereKey(QueryKey.NotifType, equalTo: NotificationType.Like.rawValue)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
    
    static func deleteFollowNotification(_ by: String, forUser: String) {
        let deleteQuery = PFQuery(className: ParseClass.Notification)
        deleteQuery.whereKey(QueryKey.By, equalTo: by)
        deleteQuery.whereKey(QueryKey.Owner, equalTo: forUser)
        deleteQuery.whereKey(QueryKey.NotifType, equalTo: NotificationType.Follow.rawValue)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }

    }
    
    static func deleteNotification(withID id: String) {
        let deleteQuery = PFQuery(className: ParseClass.Notification)
        deleteQuery.whereKey(QueryKey.UniqueID, equalTo: id)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
}
