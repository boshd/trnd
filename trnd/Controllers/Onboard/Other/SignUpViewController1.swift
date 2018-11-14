//
//  SignUpViewController.swift
//  Photograph
//
//  Created by Kareem Arab on 8/6/16.
//  Copyright © 2016 kareemarab. All rights reserved.
//

import UIKit
import Parse

class SignUpViewControllerd: UIViewController {

    // IB Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    
    fileprivate var fieldObserver: OnboardFieldObserver?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardFieldObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods: Internal
    
    /// Dismisses the keyboard
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Dismisses keyboard when touch occurs in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    // MARK: - Methods: Private
    
    /// Setup OnboardFieldObserver
    fileprivate func setupOnboardFieldObserver() {
        fieldObserver = OnboardFieldObserver(observer: self, textFields: emailTextField)
        fieldObserver?.managedButton = nextButton as! OnboardButton?
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(emailTextField):
            ErrorAlertService.displayAlertFor(.EmptyField, withPresenter: self)
            
        case EmailValidator.invalidEmail(emailTextField.text!):
            ErrorAlertService.displayAlertFor(.EmptyField, withPresenter: self)
        default:
            NavigationManager.showSignUpDetailsViewController(withPresenter: self, andEmail: emailTextField.text!)
        }
    }

    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
