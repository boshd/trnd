//
//  SignUpViewController1.swift
//  Photograph
//
//  Created by Kareem Arab on 2016-12-29.
//  Copyright © 2016 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import VBFPopFlatButton

class SignUpUserViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            usernameField.textContentType = UITextContentType(rawValue: "")
            emailField.textContentType = UITextContentType(rawValue: "")
            passwordField.textContentType = UITextContentType(rawValue: "")
        }
        nextButton.layer.cornerRadius = 10
        let fullname = UserDefaults.standard.string(forKey: DEFAULTS_FULLNAME)
        if let firstName = fullname?.components(separatedBy: " ").first {
            self.introLabel.text = "Hi \(firstName). Welcome to gif-t. Please provide the following information to sign up."
        }
        usernameField.becomeFirstResponder()
        UITextField.appearance().tintColor = .white
        usernameField.attributedPlaceholder = NSAttributedString(string: "username",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailField.attributedPlaceholder = NSAttributedString(string: "email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.indicator.isHidden = true
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 0 //Increment accordingly
        emailField.tag = 1
        passwordField.tag = 2
        
        indicator.color = UIColor.fabishPink()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
         if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
         nextField.becomeFirstResponder()
         } else {
         // Not found, so remove keyboard.
         GO()
         }
         // Do not add a line break
         
        return false
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let menu = UIMenuController.shared
        menu.isMenuVisible = false
        return false
    }
    
    // Create account for user
    func createUser() -> PFUser? {
        //guard let email = email else { return nil }
        let user = PFUser()
        user[QueryKey.FullName] = UserDefaults.standard.string(forKey: DEFAULTS_FULLNAME)
        user.username = usernameField.text!
        user.email    = emailField.text!
        user.password = passwordField.text!
        
        
        if let image = UIImage(named: "chill.jpg"), let avatarData = image.jpegData(compressionQuality: 0.5) {
            let file = PFFile(name: "avatar", data: avatarData)
            user[QueryKey.Avatar] = file
        }
        
        
        return user
    }
    
    // Sign up user
    func signUpUser(_ user: PFUser) {
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                UserDefaults.standard.set(user.username!, forKey: DEFAULTS_USERNAME)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpProfileViewController")
                //self.present(controller!, animated: false, completion: nil)
                self.navigationController?.pushViewController(controller!, animated: true)
                
                
            } else if let error = error {
                print(error)
            }
        }
    }
    
    // Creates a PFFile for an image and compresses
    func createFileFrom(image: UIImage?, withCompression compression: CGFloat) -> PFFile? {
        let image = image ?? UIImage(named: "PlaceholderAvatar")!
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        return PFFile(name: "avatar.jpeg", data: data)
    }
    
    // Methods
    func GO() {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(usernameField, emailField, passwordField):
            errLabel.text = "You forgot to fill out a field."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        case UsernameValidator.usernameInvalidLength(usernameField.text!):
            errLabel.text = "Username has to be a bit longer."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        case EmailValidator.invalidEmail(emailField.text!):
            errLabel.text = "That doesn't seem like a correct email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            errLabel.text = "keep the password over six characters"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        default:
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.nextButton.setTitle("", for: .normal)
            
            self.errLabel.isHidden = true
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)

            let query: PFQuery = PFUser.query()!
            query.whereKey("username", equalTo: usernameField.text!)
            query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.nextButton.setTitle("done", for: .normal)
                    
                    self.errLabel.text = "username taken"
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.errLabel.isHidden = true
                        self.nextButton.isEnabled = true
                    })
                } else {
                    let queryy: PFQuery = PFUser.query()!
                    queryy.whereKey("email", equalTo: self.emailField.text!)
                    queryy.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                    print("reached 1")
                        if object != nil {
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
                            self.nextButton.setTitle("done", for: .normal)
                            
                            self.errLabel.text = "Email taken. Perhaps you already have an account? Try signing in."
                            self.errLabel.isHidden  = false
                            self.nextButton.isEnabled = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                self.errLabel.isHidden = true
                                self.nextButton.isEnabled = true
                            })
                            print("reached 2")
                        } else {
                            self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                            let user = self.createUser()
                            self.signUpUser(user!)
                            print("reached 3")
                        }
                        
                    })
                
                }
            })
            
            
        }
        
    }
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFullName(_:)), name: NSNotification.Name(rawValue: "getFullName"), object: nil)
        print(UserDefaults.standard.string(forKey: DEFAULTS_FULLNAME))
        // intro label
        let fullname = UserDefaults.standard.string(forKey: DEFAULTS_FULLNAME)
        if let firstName = fullname?.components(separatedBy: " ").first {
            self.introLabel.text = "Hi \(firstName). Please provide the following information to sign up."
        }
        
        self.navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navBar.shadowImage = UIImage()
        
        let popFlatButtonLeft = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), buttonType: FlatButtonType.buttonBackType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        popFlatButtonLeft?.tintColor = UIColor.white
        popFlatButtonLeft?.addTarget(self, action: #selector(SignUpViewController.backAction(_:)), for: UIControlEvents.touchUpInside)
        let collapseButtonLeft = UIBarButtonItem(customView: popFlatButtonLeft!)
        self.navBar.topItem?.leftBarButtonItem = collapseButtonLeft
        
        self.noErrors()
        self.setupUI()
        self.nextButton.layer.cornerRadius = 8
        self.nextButton.clipsToBounds = true
        self.usernameField.layer.cornerRadius = 15
        self.usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.emailField.layer.cornerRadius = 15
        self.emailField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.passwordField.layer.cornerRadius = 15
        self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
            self.usernameField.becomeFirstResponder()
        })
        // Keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 0 //Increment accordingly
        emailField.tag = 1
        passwordField.tag = 2
     
        */
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        /*// Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            GO()
        }
        // Do not add a line break
 */
        return false
 
    }
    

    */
    
}
