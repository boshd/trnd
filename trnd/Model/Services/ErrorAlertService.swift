//
//  ErrorAlertService.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

struct ErrorAlertService {
    
    // MARK: - ErrorMessages
    
    enum ErrorMessages: String {
        case EmptyField = "Please fill out all fields"
        case SettingsEmptyField = "Username and Email fields are required"
        case InvalidUserDetails = "Invalid username or password"
        case InvalidEmail = "Please enter a valid email"
        case InvalidUsername = "Usernames can only contain letters, numbers, and underscores"
        case UsernameLength = "Usernames must be between 4 and 15 characters"
        case InvalidPassword = "Passwords must contain atleast one number and one capital letter"
        case PasswordLength = "Passwords must be atleast 6 characters long"
        case UsernameExists = "This username already exists"
        case EmailInUse = "This email is already registered to another account"
        case AccountCreation = "The account could not be created"
        case InvalidWebsite = "Please enter a valid web address"
        case CouldNotSave = "The details could not be saved. Please try again"
        case ComplaintSent = "Your report has been sent"
        case DoesNotExist = "This user does not exist"
    }
    
    // MARK: - Methods
    
    static func displayAlertFor(_ error: ErrorMessages, withPresenter presenter: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        presenter.present(alertController, animated: true, completion: nil)
    }
}
