//
//  ParseOperation.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse

typealias GETObjectsCompletion = ([PFObject]) -> Void
typealias GETDataCompletion = (NSData) -> Void
typealias GETCountCompletion = (Int32) -> Void
typealias SAVECompletion = ((Bool) -> Void)?
typealias DELETECompletion = ((Bool) -> Void)?

struct ParseOperation {
    
    static func getObjects(forQuery query: PFQuery<PFObject>, completion: @escaping GETObjectsCompletion) {
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let results = objects {
                completion(results)
            } else {
                handleError(error: error as NSError?)
            }
        }
    }
    
    static func getData(forFile file: PFFile, completion: @escaping GETDataCompletion) {
        file.getDataInBackground { (data: Data?, error: Error?) in
            if let data = data {
                completion(data as NSData)
            } else {
                handleError(error: error as NSError?)
            }
        }
    }
    
    static func countObjects(forQuery query: PFQuery<PFObject>, completion: @escaping GETCountCompletion) {
        query.countObjectsInBackground { (count: Int32, error: Error?) in
            if error != nil { handleError(error: error as NSError?) }
            completion(count)
        }
    }

    static func saveObject(object: PFObject, completion: SAVECompletion = nil) {
        object.saveInBackground { (sucess: Bool, error: Error?) in
            if sucess {
                print("Object saved successfully")
                completion?(sucess)
            } else {
                print("Could not save object")
                completion?(sucess)
            }
        }
    }
    
    static func deleteObject(object: PFObject, completion: DELETECompletion = nil) {
        object.deleteInBackground { (success: Bool, error: Error?) in
            if success {
                print("Object successfully deleted")
                completion?(success)
            } else {
                print("Could not delete object")
                completion?(success)
            }
        }
    }
    
    static func handleError(error: NSError?) {
        print(error.debugDescription)
    }
}
