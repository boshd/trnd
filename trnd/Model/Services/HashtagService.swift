//
//  HashtagService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETHashtagUniqueIDs = ([String]) -> Void

struct HashtagService {
    
    // Creates a hashtag if it exists in text
    static func createHashtagIfExists(_ text: String?, forID id: String) {
        guard let text = text else { return }
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for word in words {
            if word.hasPrefix("#") {
                HashtagService.createHashtag(word, commentID: id, comment: text)
            }
        }
    }
    
    // Retrieves all the uniqueIDs associated with a hashtag
    static func retrieveUniqueIDsForHashtag(_ hashtag: String, withLimit limit: Int, completion: @escaping GETHashtagUniqueIDs) {
        let hashtagQuery = PFQuery(className: ParseClass.Hashtag)
        hashtagQuery.whereKey(QueryKey.Hashtag, equalTo: hashtag)
        hashtagQuery.limit = limit
        ParseOperation.getObjects(forQuery: hashtagQuery) { (objects: [PFObject]) in
            var uniqueIDs  = [String]()
            
            for object in objects {
                uniqueIDs.append(object.value(forKey: QueryKey.To) as! String)
            }
            completion(uniqueIDs)
        }
    }
    // Creates a hashtag in lowercase format, without symbols or punctuation
    fileprivate static func createHashtag(_ input: String, commentID: String, comment: String) {
        guard input.characters.count > 4 else { return }
        guard let currentUsername = PFUser.current()?.username else { return }
        
        var word = input
        word = word.trimmingCharacters(in: CharacterSet.symbols)
        word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
        let hashtag = PFObject(className: ParseClass.Hashtag)
        hashtag[QueryKey.To] = commentID
        hashtag[QueryKey.By] = currentUsername
        hashtag[QueryKey.Hashtag] = word.lowercased()
        hashtag[QueryKey.Comment] = comment
        ParseOperation.saveObject(object: hashtag)
    }
    
    // Deletes hashtag from a post
    static func deleteHashtag(withID id: String, byUsername name: String, forComment comment: String) {
        let hashtagQuery = PFQuery(className: ParseClass.Hashtag)
        hashtagQuery.whereKey(QueryKey.To, equalTo: id)
        hashtagQuery.whereKey(QueryKey.By, equalTo: name)
        hashtagQuery.whereKey(QueryKey.Comment, equalTo: comment)
        ParseOperation.getObjects(forQuery: hashtagQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
    
    static func deleteHashtag(withID id: String) {
        let hashtagQuery = PFQuery(className: ParseClass.Hashtag)
        hashtagQuery.whereKey(QueryKey.To, equalTo: id)
        ParseOperation.getObjects(forQuery: hashtagQuery) { (objects: [PFObject]) in
            for object in objects {
                ParseOperation.deleteObject(object: object)
            }
        }
    }
}
