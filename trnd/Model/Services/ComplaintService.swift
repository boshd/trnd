//
//  ComplaintService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
///

import Foundation
import Parse

typealias ComplaintCompletion = (() -> Void)?

struct ComplaintService {
    
    static func createComplaintFor(_ comment: String, withPostID id: String, reportedUser user: String, completion: ComplaintCompletion) {
        guard let complaintOwner = PFUser.current()?.username else { return }
        let complaint = PFObject(className: ParseClass.Complaint)
        complaint[QueryKey.By] = complaintOwner
        complaint[QueryKey.Post] = id
        complaint[QueryKey.To] = comment
        complaint[QueryKey.ReportedUser] = user
        ParseOperation.saveObject(object: complaint) { (success: Bool) in
            if success { completion?() }
        }
    }
}
