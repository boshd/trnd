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
import KRProgressHUD

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    //@IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var revealButton: UIButton!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var username = UserDefaults.standard.string(forKey: DEFAULTS_USERNAME)
    var email = UserDefaults.standard.string(forKey: DEFAULTS_EMAIL)
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
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
        return .default
    }
    
    // LIFE CYCLE
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordField.becomeFirstResponder()
        self.nextButton.backgroundColor =  UIColor.offGreen()
        self.nextButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        passwordField.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        passwordField.resignFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //hideKeyboardWhenTappedAround()
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.title = "TRND"
        self.view.backgroundColor = UIColor.offBlack()
        //self.navigationItem.hidesBackButton = false
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Basdck", style: .plain, target: nil, action: nil)
        let yourBackImage = UIImage(from: .fontAwesome, code: "angleleft", textColor: .white, backgroundColor: .clear, size: CGSize(width: 60, height: 60))
        let bb = UIBarButtonItem(image: yourBackImage, style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = bb
        
        //self.title = "TRND"
        if #available(iOS 11, *) {
            // Disables the password autoFill accessory view.
            passwordField.textContentType = UITextContentType(rawValue: "")
        }

        UITextField.appearance().tintColor = UIColor.litGreen()
        passwordField.delegate = self


        passwordField.addTarget(self, action:#selector(PasswordViewController.passwordChanged), for: UIControl.Event.editingChanged)
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(PasswordViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(PasswordViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
                
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
 
    @objc func passwordChanged() {
        self.nextButton.backgroundColor =  UIColor.litGreen()
        self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
        self.nextButton.isEnabled = true
        switch true {
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            errLabel.text = "Password must be longer than six characters."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
        default:
            self.nextButton.backgroundColor =  UIColor.litGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
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
        
//        if let image = UIImage(named: "kikz.jpeg"), let avatarData = image.jpegData(compressionQuality: 0.5) {
//            let file = PFFile(name: "avatar", data: avatarData)
//            user[QueryKey.Avatar] = file
//        }
        
        
        
        return user
    }
    
    // Sign up user
    func signUpUser(_ user: PFUser) {
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                UserDefaults.standard.set(user.username!, forKey: DEFAULTS_USERNAME)
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.login()
                let story = UIStoryboard(name: "Onboard", bundle: nil)
                let controller = story.instantiateViewController(withIdentifier: "SignUpProfileViewController")
                self.navigationController?.pushViewController(controller, animated: true)
                KRProgressHUD.dismiss()
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
        KRProgressHUD.show()
        self.passwordField.isEnabled = false
        switch true {
        case TextFieldValidator.emptyFieldExists(passwordField):
            KRProgressHUD.dismiss()
            errLabel.text = "please enter password."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
                self.passwordField.isEnabled = true
            })
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            KRProgressHUD.dismiss()
            errLabel.text = "keep the password over six characters"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
                self.passwordField.isEnabled = true
            })
        default:
            //self.nextButton.setTitle("", for: .normal)
            
            self.errLabel.isHidden = true
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = UIColor.offGreen()
            
            let user = self.createUser()
            self.signUpUser(user!)
            
        }
        
    }
    
}
