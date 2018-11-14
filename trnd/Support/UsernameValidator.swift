//
//  UsernameValidator.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation

struct UsernameValidator {
    
    // Checks if username only uses valid characters: A-Z, a-z, and _
    static func invalidCharactersIn(username: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890")
        return username.rangeOfCharacter(from: characterSet.inverted) != nil
    }
    
    // Checks if username is between 4 & 15 characters
    static func usernameInvalidLength(_ username: String) -> Bool {
        return username.characters.count < 4 || username.characters.count > 15
    }
}
