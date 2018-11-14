//
//  ViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    fileprivate var fieldObserver: OnboardFieldObserver?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardFieldObserver()
        UITextField.appearance().tintColor = UIColor.fabishPink()
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.clipsToBounds = true
        
        self.usernameField.layer.cornerRadius = 15
        self.passwordField.layer.cornerRadius = 15
        
        self.usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        self.usernameField.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods: Internal
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /// Dismisses the keyboard
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// Dismisses keyboard when touch occurs in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    /// Returns a light statusbar style by default
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Methods: Private
    
    /// Setup OnboardFieldObserver
    fileprivate func setupOnboardFieldObserver() {
        fieldObserver = OnboardFieldObserver(observer: self, textFields: usernameField, passwordField)
        //fieldObserver?.managedButton = loginButton
    }
    
    /// Attemps to sign a user in with username and password
    fileprivate func attemptSignInWith(username: String, andPassword password: String, completion: @escaping (Bool) -> Void) {
        //loginButton.configureForState(true)
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error) in
            if error != nil {
                print(error.debugDescription)
                completion(false)
            } else {
                if let user = user, let name = user.username {
                    print(name)
                    UserDefaults.standard.set(name, forKey: DEFAULTS_USERNAME)
                    UserDefaults.standard.synchronize()
                    completion(true)
                }
            }
            //self.loginButton.configureForState(false)
        }
    }
    
    /// Presents the Facebook login screen for the user to login
    fileprivate func attemptFacebookLogin() {

    }
    
    // MARK: - IBActions
    
    @IBAction func logInButtonPressed(_ sender: AnyObject) {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(usernameField, passwordField):
            ErrorAlertService.displayAlertFor(.EmptyField, withPresenter: self)
            
        default:
            attemptSignInWith(username: usernameField.text!, andPassword: passwordField.text!) { (success: Bool) in
                if success {
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.login()
                    self.dismissKeyboard()
                } else {
                   ErrorAlertService.displayAlertFor(.InvalidUserDetails, withPresenter: self)
                }
            }
        }
    }
    
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        attemptFacebookLogin()
        
        // FIXME: - if user is new user, sign user up for service
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        NavigationManager.showEmailSignUpViewController(withPresenter: self)
    }
}

