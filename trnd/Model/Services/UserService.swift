//
//  UserService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETUserCompletion = (PFUser?, Bool) -> Void
typealias GETImageCompletion = (UIImage) -> Void

struct UserService {
    
    // Retrieves the user object with a name
    static func getUserWithName(_ name: String, completion: @escaping GETUserCompletion) {
        let query = PFQuery(className: ParseClass.User)
        query.whereKey(QueryKey.Username, equalTo: name)
        
        ParseOperation.getObjects(forQuery: query) { (objects: [PFObject]) in
            if let user = objects.first as? PFUser {
                completion(user, true)
            } else {
                completion(nil, false)
            }
        }
    }
    
    // Gets the avatar image for a user
    static func getAvatarImgForUser(_ user: PFUser, completion: @escaping GETImageCompletion) {
        if let file = user.object(forKey: QueryKey.Avatar) as? PFFile {
            ParseOperation.getData(forFile: file) { (data: NSData) in
                guard let image = UIImage(data: data as Data) else { return }
                completion(image)
            }
        }
    }
    
    // Updates the users information
    static func saveUserDetails(_ user: PFUser, completion: @escaping (Bool) -> Void) {
        user.saveInBackground { (success: Bool, error: Error?) in
            if error != nil {
                print(error.debugDescription)
            } else {
                completion(success)
            }
        }
    }
}
