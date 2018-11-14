//
//  passwordViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import VBFPopFlatButton

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    var username = UserDefaults.standard.string(forKey: DEFAULTS_USERNAME)
    var email = UserDefaults.standard.string(forKey: DEFAULTS_EMAIL)
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func revealAction(_ sender: Any) {
        if revealButton.titleLabel?.text == "hide" {
            passwordField.isSecureTextEntry = true
            self.revealButton.setTitle("show", for: .normal)
        } else if revealButton.titleLabel?.text == "show"{
            passwordField.isSecureTextEntry = false
            self.revealButton.setTitle("hide", for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "TRND"
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            passwordField.textContentType = UITextContentType(rawValue: "")
        }
        nextButton.layer.cornerRadius = 10
        let username = UserDefaults.standard.string(forKey: DEFAULTS_USERNAME)
        if let username = username {
            self.introLabel.text = "hey @\(username). pick a secure password yo."
        }
        passwordField.becomeFirstResponder()
        UITextField.appearance().tintColor = .white
        self.indicator.isHidden = true
        passwordField.delegate = self
        
        indicator.color = UIColor.fabishPink()
        nextButton.isEnabled = false
        nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        passwordField.addTarget(self, action:#selector(PasswordViewController.passwordChanged), for: UIControl.Event.editingChanged)
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(PasswordViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(PasswordViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.buttonView.frame.origin.y == 0{
                self.buttonView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.buttonView.frame.origin.y != 0{
                self.buttonView.frame.origin.y += keyboardSize.height
            }
        }
    }
 
    @objc func passwordChanged() {

        switch true {
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            errLabel.text = "Password must be longer than six characters."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        default:
            self.nextButton.backgroundColor =  UIColor.white
            //self.nextButton.backgroundColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
            self.errLabel.isHidden = true
            self.nextButton.isEnabled = true

        }
    }
    
    func switchStateDidChange(_ sender:UISwitch!) {
        if (sender.isOn == true){
            passwordField.isSecureTextEntry = true
        }
        else{
            passwordField.isSecureTextEntry = false
        }
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
        user.username = UserDefaults.standard.string(forKey: DEFAULTS_USERNAME_)
        user.email = UserDefaults.standard.string(forKey: DEFAULTS_EMAIL)
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
                self.navigationController?.pushViewController(controller!, animated: false)
                
                
            } else if let error = error {
                print(error)
                self.passwordField.isEnabled = true
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
        self.passwordField.isEnabled = false
        switch true {
        case TextFieldValidator.emptyFieldExists(passwordField):
            errLabel.text = "please enter password."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
                self.passwordField.isEnabled = true
            })
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            errLabel.text = "keep the password over six characters"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
                self.passwordField.isEnabled = true
            })
        default:
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.nextButton.setTitle("", for: .normal)
            
            self.errLabel.isHidden = true
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
            
            let user = self.createUser()
            self.signUpUser(user!)
            
        }
        
    }
    
}
