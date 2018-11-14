//
//  TextFieldDelegate.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

final class OnboardFieldObserver: NSObject {
    
    // MARK: - Properties
    var observer: UIViewController
    var managedTextFields: [UITextField]
    var managedButton: OnboardButton?
    
    // MARK: - Initializer
    init(observer: UIViewController, textFields: UITextField...) {
        self.observer = observer
        self.managedTextFields = textFields
        super.init()
        textFields.forEach { $0.delegate = self }
    }
}

// MARK: - Extension: UITextFieldDelegate

extension OnboardFieldObserver: UITextFieldDelegate {
    
    /// Enables or disables text field based on contents
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isDisabled = TextFieldValidator.emptyFieldExists(managedTextFields)
        managedButton?.configureForState(isDisabled)
    }
    
    /// Dismisses keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        observer.view.endEditing(true)
        return true
    }
}
