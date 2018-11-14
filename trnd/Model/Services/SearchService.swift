//
//  SearchService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias SearchUsersCompletion = ([String], [PFFile]) -> Void

struct SearchService {
    
    static func getUsersWhere(queryKey key: String, contains text: String, withLimit limit: Int, completion: @escaping SearchUsersCompletion) {
        let userQuery = PFQuery(className: ParseClass.User)
        userQuery.whereKey(key, matchesRegex: "(?i)" + text)
        userQuery.limit = limit
        ParseOperation.getObjects(forQuery: userQuery) { (objects: [PFObject]) in
            var files = [PFFile]()
            var usernames = [String]()
            
            for object in objects {
                files.append(object.value(forKey: QueryKey.Avatar) as! PFFile)
                usernames.append(object.value(forKey: QueryKey.Username) as! String)
            }
            completion(usernames, files)
        }
    }
}
