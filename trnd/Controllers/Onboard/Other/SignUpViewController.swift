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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var backButton: VBFPopFlatButton!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var introLabel: UILabel!

    @IBOutlet weak var buttonView2: UIView!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var usernameTaken: UILabel!
    @IBOutlet weak var usernameTakenLabel: UILabel!
    @IBOutlet weak var usernameLengthLabel: UILabel!
    @IBOutlet weak var weakPasswordLabel: UILabel!
    @IBOutlet weak var emptyFieldLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var fullname = "not real"
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    // Methods
    func GO() {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(usernameField, emailField, passwordField):
            noErrors()
            
            emptyFieldLabel.isHidden  = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.noErrors()
            })
            
            //case UsernameValidator.invalidCharactersIn(username: usernameField.text!):
            
            
        case UsernameValidator.usernameInvalidLength(usernameField.text!):
            noErrors()
            usernameLengthLabel.isHidden  = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.noErrors()
            })
        case EmailValidator.invalidEmail(emailField.text!):
            noErrors()
            invalidEmailLabel.isHidden  = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.noErrors()
            })
        //case PasswordValidator.passwordInvalidLength(passwordField.text!):
            
            
        case PasswordValidator.passwordTooWeak(passwordField.text!):
            noErrors()
            weakPasswordLabel.isHidden  = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.noErrors()
            })
        default:
            //self.noErrors()
            //self.nextButton.isHidden = true
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
            //self.indicator.isHidden = false
            //self.indicator.startAnimating()
            let query: PFQuery = PFUser.query()!
            query.whereKey("username", equalTo: usernameField.text!)
            query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.noErrors()
                    self.setupUI()
                    self.usernameTaken.isHidden = false
                    //self.indicator.stopAnimating()
                }
                else {
                    //self.view.endEditing(true)
                    self.noErrors()
                    //self.nextButton.isHidden = true
                    self.nextButton.isEnabled = false
                    self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    //self.indicator.isHidden = false
                    //self.indicator.startAnimating()
                    
                    let user = self.createUser()
                    self.signUpUser(user!)
                    
                }
            })
            
            
        }
        
    }

    func truee() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        popFlatButtonLeft?.addTarget(self, action: #selector(SignUpViewController.backAction(_:)), for: UIControl.Event.touchUpInside)
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.tag = 0 //Increment accordingly
        emailField.tag = 1
        passwordField.tag = 2

        UITextField.appearance().tintColor = .fabishPink()
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //self.view.endEditing(true)
    
        
    }
    
    func setupUI() {
        
        self.nextButton.isEnabled = true
        self.nextButton.tintColor = UIColor(red:1.00, green:0.31, blue:0.45, alpha:1.0)
        nextButton.isHidden = false
        self.nextButton.setTitle("next", for: .normal)
        //indicator.isHidden = true
        
    }
    
    // keyboard shows and pushes view
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
    }
    
    // keyboard hides and pulls view
    @objc func keyboardWillHide(notification: NSNotification) {

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
    
    // Disable Error Prompts
    func noErrors() {
        
        usernameTakenLabel.isHidden  = true
        usernameLengthLabel.isHidden = true
        weakPasswordLabel.isHidden   = true
        emptyFieldLabel.isHidden     = true
        invalidEmailLabel.isHidden   = true
        usernameTaken.isHidden       = true
        
    }
    
    @objc func getFullName(_ notification: NSNotification) {
        
        if let fullnamee = notification.userInfo?["fullname"] as? String {
            
            fullname = fullnamee
            
        }
    }
    
    // Create account for user
    func createUser() -> PFUser? {
        //guard let email = email else { return nil }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getFullName(_:)), name: NSNotification.Name(rawValue: "getFullName"), object: nil)
        
        let user = PFUser()
        //user[QueryKey.FullName] = fullname
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
    
    /// Creates a PFFile for an image and compresses
    func createFileFrom(image: UIImage?, withCompression compression: CGFloat) -> PFFile? {
        let image = image ?? UIImage(named: "PlaceholderAvatar")!
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        return PFFile(name: "avatar.jpeg", data: data)
    }
    
    // Sign up user
    func signUpUser(_ user: PFUser) {
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                //self.indicator.stopAnimating()
                self.setupUI()
                UserDefaults.standard.set(user.username!, forKey: DEFAULTS_USERNAME)
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpProfileViewController")
                self.present(controller!, animated: false, completion: nil)
                //self.navigationController?.pushViewController(controller!, animated: true)
                
            } else if let error = error {
                //self.indicator.stopAnimating()
                self.setupUI()
                print(error)
            }
        }
    }

    
}
