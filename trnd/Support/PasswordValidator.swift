//
//  PasswordValidator.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation

struct PasswordValidator {
    
    // Checks if a password is greater than 6 characters
    static func passwordInvalidLength(_ password: String) -> Bool {
        return password.characters.count < 6
    }
    
    // Checks if password contains atleast one number and one capital letter
    static func passwordTooWeak(_ password: String) -> Bool {
        let capitalSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let numberSet = CharacterSet(charactersIn: "0123456789")
        return password.rangeOfCharacter(from: capitalSet) == nil || password.rangeOfCharacter(from: numberSet) == nil
    }
}
