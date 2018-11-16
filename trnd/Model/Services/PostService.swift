//
//  PostService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//


// TODO: - Make sure all users sign up with default avatar if no image selected

import UIKit
import Parse
import FLAnimatedImage

typealias GETThumbCompletion = ([String], [String], [String], [PFFile]) -> Void
typealias GETPostCompletion = (String, PFFile, Date, PFFile, String?, String, String, String) -> Void
typealias GETPostsCompletion = ([String], [PFFile], [Date], [PFFile], [String], [String], [String], [String], [String]) -> Void


struct PostService {

    // Retrives the uniqueIDs and files for posts of user with a given name
    static func getPostsForName(_ name: String, withLimit limit: Int, completion: @escaping GETThumbCompletion) {
        
        let postsQuery = PFQuery(className: ParseClass.Post)
        postsQuery.whereKey(QueryKey.Username, equalTo: name)
        postsQuery.order(byDescending: QueryKey.CreatedAt)
        postsQuery.limit = limit
        
        ParseOperation.getObjects(forQuery: postsQuery) { (objects: [PFObject]) in
            var uniqueIDs = [String]()
            var pictureFiles = [PFFile]()
            var latitudes = [String]()
            var longitudes = [String]()
            for post in objects {
                uniqueIDs.append(post.value(forKey: QueryKey.UniqueID) as! String)
                pictureFiles.append(post.value(forKey: QueryKey.Picture) as! PFFile)
                latitudes.append(post.value(forKey: QueryKey.Latitude) as! String)
                longitudes.append(post.value(forKey: QueryKey.Longitude) as! String)
            }
            completion(uniqueIDs, latitudes, longitudes, pictureFiles)
        }
    }
    
    // Retrieves a post with a specific uniqueID
    static func getPostWithUUID(uniqueID id: String, completion: @escaping GETPostCompletion) {
        let postQuery = PFQuery(className: ParseClass.Post)
        postQuery.whereKey(QueryKey.UniqueID, equalTo: id)
        ParseOperation.getObjects(forQuery: postQuery) { (objects: [PFObject]) in
            if let post = objects.first {
                let username = post.value(forKey: QueryKey.Username) as! String
                let avatar = post.value(forKey: QueryKey.Avatar) as! PFFile
                let date = post.value(forKey: QueryKey.CreatedAt) as! Date
                let file = post.value(forKey: QueryKey.Picture) as! PFFile
                let title = post.value(forKey: QueryKey.Title) as? String ?? ""
                let location = post.value(forKey: QueryKey.Location) as? String ?? ""
                let latitude = post.value(forKey: QueryKey.Latitude) as! String ?? ""
                let longitude = post.value(forKey: QueryKey.Latitude) as! String ?? ""
                completion(username, avatar, date, file, title, location, latitude, longitude)
            }
        }
    }
    
    // Retrieves all posts with a uniqueID contained in a list of IDs
    static func getPostsWithUUIDs(uniqueIDs ids: [String], completion: @escaping GETThumbCompletion) {
        let postQuery = PFQuery(className: ParseClass.Post)
        postQuery.whereKey(QueryKey.UniqueID, containedIn: ids)
        ParseOperation.getObjects(forQuery: postQuery) { (objects: [PFObject]) in
            var uniqueIDs = [String]()
            var files = [PFFile]()
            var latitudes = [String]()
            var longitudes = [String]()
            for object in objects {
                uniqueIDs.append(object.value(forKey: QueryKey.UniqueID) as! String)
                files.append(object.value(forKey: QueryKey.Picture) as! PFFile)
                latitudes.append(object.value(forKey: QueryKey.Latitude) as! String)
                longitudes.append(object.value(forKey: QueryKey.Longitude) as! String)
            }
            completion(uniqueIDs, latitudes, longitudes, files)
        }
    }
    
    // Retrieves all posts for a list of usernames with a specified limit
    static func getPostsForNames(_ names: [String], withLimit limit: Int, completion: @escaping GETPostsCompletion) {
        let postsQuery = PFQuery(className: ParseClass.Post)
        postsQuery.whereKey(QueryKey.Username, containedIn: names)
        postsQuery.limit = limit
        postsQuery.addDescendingOrder(QueryKey.CreatedAt)
        
        ParseOperation.getObjects(forQuery: postsQuery) { (objects: [PFObject]) in
            
            var usernames = [String]()
            var avatarFiles = [PFFile]()
            var dates = [Date]()
            var postFiles = [PFFile]()
            var postDescriptions = [String]()
            var locations = [String]()
            var latitudes = [String]()
            var longitudes = [String]()
            var uniqueIDs = [String]()
            
            for post in objects {
                usernames.append(post.value(forKey: QueryKey.Username) as! String)
                avatarFiles.append(post.value(forKey: QueryKey.Avatar) as! PFFile)
                dates.append(post.value(forKey: QueryKey.CreatedAt) as! Date)
                postFiles.append(post.value(forKey: QueryKey.Picture) as! PFFile)
                postDescriptions.append(post.value(forKey: QueryKey.Title) as? String ?? "")
                locations.append(post.value(forKey: QueryKey.Location) as? String ?? "")
                latitudes.append(post.value(forKey: QueryKey.Latitude) as? String ?? "")
                longitudes.append(post.value(forKey: QueryKey.Longitude) as? String ?? "")
                uniqueIDs.append(post.value(forKey: QueryKey.UniqueID) as! String)
            }
            
            completion(usernames, avatarFiles, dates, postFiles, postDescriptions, locations, latitudes, longitudes, uniqueIDs)
        }
    }
    
    // Retrieves all posts
    static func getAllPosts( withLimit limit: Int, completion: @escaping GETPostsCompletion) {
        let postsQuery = PFQuery(className: ParseClass.Post)
        postsQuery.addDescendingOrder(QueryKey.CreatedAt)
        
        ParseOperation.getObjects(forQuery: postsQuery) { (objects: [PFObject]) in
            
            var usernames = [String]()
            var avatarFiles = [PFFile]()
            var dates = [Date]()
            var postFiles = [PFFile]()
            var postDescriptions = [String]()
            var locations = [String]()
            var latitudes = [String]()
            var longitudes = [String]()
            var uniqueIDs = [String]()
            
            for post in objects {
                usernames.append(post.value(forKey: QueryKey.Username) as! String)
                avatarFiles.append(post.value(forKey: QueryKey.Avatar) as! PFFile)
                dates.append(post.value(forKey: QueryKey.CreatedAt) as! Date)
                postFiles.append(post.value(forKey: QueryKey.Picture) as! PFFile)
                postDescriptions.append(post.value(forKey: QueryKey.Title) as? String ?? "")
                locations.append(post.value(forKey: QueryKey.Location) as? String ?? "")
                latitudes.append(post.value(forKey: QueryKey.Latitude) as? String ?? "")
                longitudes.append(post.value(forKey: QueryKey.Longitude) as? String ?? "")
                uniqueIDs.append(post.value(forKey: QueryKey.UniqueID) as! String)
            }
            
            completion(usernames, avatarFiles, dates, postFiles, postDescriptions, locations, latitudes, longitudes, uniqueIDs)
        }
    }
    
    // Gets the count of posts for user
    static func getPostCountFor(_ name: String, completion: @escaping GETCountCompletion) {
        let query = PFQuery(className: ParseClass.Post)
        query.whereKey(QueryKey.Username, equalTo: name)
        ParseOperation.countObjects(forQuery: query) { (count: Int32) in
            completion(count)
        }
    }
    
    static func getNewestPosts(withLimit limit: Int, completion: @escaping GETThumbCompletion) {
        let query = PFQuery(className: ParseClass.Post)
        query.order(byDescending: QueryKey.CreatedAt)
        query.limit = limit
        ParseOperation.getObjects(forQuery: query) { (objects: [PFObject]) in
            
            var uniqueIDs = [String]()
            var files = [PFFile]()
            var latitudes = [String]()
            var longitudes = [String]()
            
            for object in objects {
                uniqueIDs.append(object.value(forKey: QueryKey.UniqueID) as! String)
                files.append(object.value(forKey: QueryKey.Picture) as! PFFile)
                latitudes.append(object.value(forKey: QueryKey.Latitude) as! String)
                longitudes.append(object.value(forKey: QueryKey.Longitude) as! String)
            }
            completion(uniqueIDs, latitudes, longitudes, files)
        }
    }
    
    static func createPostWith(_ gifUrl: URL, title: String?, location: String, latitude: String, longitude: String, successBlock: @escaping () -> Void) {
        guard let currentUser = PFUser.current() else { return }
        let uniqueID = "\(currentUser.username!)\(UUID().uuidString)"
        let object = PFObject(className: ParseClass.Post)
        object[QueryKey.Username] = currentUser.username
        object[QueryKey.Avatar] = currentUser.value(forKey: QueryKey.Avatar) as? PFFile
        object[QueryKey.UniqueID] = uniqueID
        object[QueryKey.Title] = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        object[QueryKey.Location] = location ?? ""
        object[QueryKey.Latitude] = latitude ?? ""
        object[QueryKey.Longitude] = longitude ?? ""
        
        do {
            let file = try PFFile(data: Data(contentsOf: gifUrl) as Data)
            object[QueryKey.Picture] = file
            //}
            
            ParseOperation.saveObject(object: object) { (success: Bool) in
                if success { successBlock() }
            }
            
            HashtagService.createHashtagIfExists(title, forID: uniqueID)
            NotificationService.checkForMention(title, uniqueID: uniqueID, notifOwner: currentUser.username!)
            print("inisde create")
        } catch  {
            //
        }
        
        
        //let file = PFFile(name: "\(uniqueID).jpeg", data: image as Data)
        
        //if let imageData = UIImageJPEGRepresentation(image, 0.5) {
        //let file = PFFile(name: "post.mp4", data: image as Data)
        
    }
    
    // Creates a post with an image and description
    static func createPostWith(_ image: NSData, title: String?, location: String, latitude: String, longitude: String, successBlock: @escaping () -> Void) {
        print("r1")
        guard let currentUser = PFUser.current() else { return }
        print("r2")
        let uniqueID = "\(currentUser.username!)\(UUID().uuidString)"
        print("r3")
        let object = PFObject(className: ParseClass.Post)
        print("r4")
        object[QueryKey.Username] = currentUser.username
        print("r6")
        object[QueryKey.Avatar] = currentUser.value(forKey: QueryKey.Avatar) as? PFFile
        print("r7")
        object[QueryKey.UniqueID] = uniqueID
        object[QueryKey.Title] = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        object[QueryKey.Location] = location ?? ""
        object[QueryKey.Latitude] = latitude ?? ""
        object[QueryKey.Longitude] = longitude ?? ""

        let file = PFFile(data: image as Data)
        //let file = PFFile(name: "\(uniqueID).jpeg", data: image as Data)

        //if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            //let file = PFFile(name: "post.mp4", data: image as Data)
        object[QueryKey.Picture] = file
        //}
        
        ParseOperation.saveObject(object: object) { (success: Bool) in
            if success { successBlock() }
        }
        
        HashtagService.createHashtagIfExists(title, forID: uniqueID)
        NotificationService.checkForMention(title, uniqueID: uniqueID, notifOwner: currentUser.username!)
        print("inisde create")
    }
    
    // Creates a post with an video and description
    static func createPostWithVideo(_ videoData: NSData, title: String?, location: String, latitude: String, longitude: String, successBlock: @escaping () -> Void) {
        print("began post")
        guard let currentUser = PFUser.current() else { return }
        let uniqueID = "\(currentUser.username!)\(UUID().uuidString)"
        let object = PFObject(className: ParseClass.Post)
        object[QueryKey.Username] = currentUser.username
        object[QueryKey.Avatar] = currentUser.value(forKey: QueryKey.Avatar) as? PFFile
        object[QueryKey.UniqueID] = uniqueID
        object[QueryKey.Title] = title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        object[QueryKey.Location] = location ?? ""
        object[QueryKey.Latitude] = latitude ?? ""
        object[QueryKey.Longitude] = longitude ?? ""
        
        //let file = PFFile(name: "GIF_POST.gif", data: video as Data)
        
        //if let imageData = UIImageJPEGRepresentation(image, 0.5) {
        //let file = PFFile(name: "post.mp4", data: image as Data)
        //object[QueryKey.Video] = file
        //}
        
        ParseOperation.saveObject(object: object) { (success: Bool) in
            if success { successBlock() }
        }
        
        HashtagService.createHashtagIfExists(title, forID: uniqueID)
        NotificationService.checkForMention(title, uniqueID: uniqueID, notifOwner: currentUser.username!)
    
    }
    
    static func deletePostWith(uniqueID id: String) {
        let deleteQuery = PFQuery(className: ParseClass.Post)
        deleteQuery.whereKey(QueryKey.UniqueID, equalTo: id)
        ParseOperation.getObjects(forQuery: deleteQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
}
















