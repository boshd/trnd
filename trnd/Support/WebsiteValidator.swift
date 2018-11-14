//
//  WebsiteValidator.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation

struct WebsiteValidator {
    
    static func invalidWebsite(_ website: String) -> Bool {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
        let range = website.range(of: regex, options: .regularExpression)
        return range != nil ? false : true
    }
    
}
