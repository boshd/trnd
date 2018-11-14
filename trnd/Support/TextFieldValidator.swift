//
//  TextFieldValidator.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

struct TextFieldValidator {
    
    // Check for the existence of an empty text field, variadic input
    static func emptyFieldExists(_ textFields: UITextField...) -> Bool {
        for field in textFields {
            if field.text!.isEmpty {
                return true
            }
        }
        return false
    }
    
    // Check for the existence of an empty text field, array input
    static func emptyFieldExists(_ textFields: [UITextField]) -> Bool {
        for field in textFields {
            if field.text!.isEmpty {
                return true
            }
        }
        return false
    }

}
