//
//  emailViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import TextFieldEffects
import KRProgressHUD

class UsernameEmailViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    //@IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var user_bool: Bool = false
    var email_bool: Bool = false
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var keyboardHeightLayoutConstraint_ind: NSLayoutConstraint?
    @IBOutlet var keyboardHeightLayoutConstraint_viewNscroll: NSLayoutConstraint?
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        //GO()
    }
    
    @IBAction func next(_ sender: Any) {
        GO()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            //textField.resignFirstResponder()
            GO()
        }
        
        return true
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        //GO()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.becomeFirstResponder()
        check_bools()
        //usernameChanged()
        //emailChanged()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        usernameField.resignFirstResponder()
        
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
        

        UITextField.appearance().tintColor = .white
        usernameField.delegate = self
        emailField.delegate = self
    
        
        usernameField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        
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
                self.keyboardHeightLayoutConstraint_ind?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                self.keyboardHeightLayoutConstraint_ind?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @objc func check_bools() {
        if user_bool && email_bool {
            self.nextButton.backgroundColor =  UIColor.litGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            self.errLabel.isHidden = true
            self.nextButton.isEnabled = true
            self.emailField.enablesReturnKeyAutomatically = true
            print("im hereeeeeeee yooo")
        } else {
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            self.emailField.enablesReturnKeyAutomatically = false
            print("still not there yooo")
        }
    }
    
    @objc func usernameChanged() {
        user_bool = false
        switch true {
        case UsernameValidator.usernameInvalidLength(usernameField.text!):
            user_bool = false
            errLabel.text = " 4 < username < 14 :')"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            self.emailField.enablesReturnKeyAutomatically = false
        default:
            
            //print("here")
            //errLabel.text = ""
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            let query: PFQuery = PFUser.query()!
            query.whereKey("username", equalTo: usernameField.text!)
            query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.user_bool = false
                    self.nextButton.setTitle("next", for: .normal)
                    
                    self.errLabel.text = "Username taken."
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor =  UIColor.offGreen()
                    self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
                    self.emailField.enablesReturnKeyAutomatically = false
                    print("username taken")
                } else {
                    self.errLabel.text = ""
                    self.user_bool = true
                    self.check_bools()
                }
            })
        }
    }
    
    
    
    @objc func emailChanged() {
        email_bool = false
        self.errLabel.text = ""
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            email_bool = false
            errLabel.text = "Fields can't be empty."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            self.emailField.enablesReturnKeyAutomatically = false
        case EmailValidator.invalidEmail(emailField.text!):
            email_bool = false
            errLabel.text = "Are you sure this email is valid?"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
            self.emailField.enablesReturnKeyAutomatically = false
        default:
            
            let queryy: PFQuery = PFUser.query()!
            queryy.whereKey("email", equalTo: self.emailField.text!)
            queryy.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.email_bool = false
                    self.errLabel.text = "Email taken."
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    self.emailField.enablesReturnKeyAutomatically = false
                    print("reached 2")
                } else {
                    self.errLabel.text = ""
                    self.email_bool = true
                    self.check_bools()
                }
            })
        }
    }
    
    // Methods
    func GO() {
        KRProgressHUD.show()
        nextButton.titleLabel?.text = ""
        nextButton.backgroundColor = UIColor.offGreen()
        nextButton.isEnabled = false
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            
            KRProgressHUD.dismiss()
            self.nextButton.titleLabel?.text = "Next"
            self.nextButton.backgroundColor = UIColor.litGreen()
            self.nextButton.isEnabled = true
            errLabel.text = "Email can't be empty"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            }
        case EmailValidator.invalidEmail(emailField.text!):
            KRProgressHUD.dismiss()
            self.nextButton.titleLabel?.text = "Next"
            self.nextButton.backgroundColor = UIColor.litGreen()
            self.nextButton.isEnabled = true
            errLabel.text = "Please enter a valid email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        default:
            let username_query: PFQuery = PFUser.query()!
            username_query.whereKey("username", equalTo: usernameField.text!)
            username_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.nextButton.setTitle("Next", for: .normal)
                    
                    self.errLabel.text = "username taken"
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.errLabel.isHidden = true
                        self.nextButton.isEnabled = true
                    })
                    self.nextButton.titleLabel?.text = "Next"
                    self.nextButton.backgroundColor = UIColor.litGreen()
                    self.nextButton.isEnabled = true
                    KRProgressHUD.dismiss()
                } else {
                    let email_query: PFQuery = PFUser.query()!
                    email_query.whereKey("email", equalTo: self.emailField.text!)
                    email_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                        if object != nil {
                            self.nextButton.setTitle("Next", for: .normal)
                            
                            self.errLabel.text = "Email taken. Try signing in."
                            self.errLabel.isHidden  = false
                            self.nextButton.isEnabled = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                self.errLabel.isHidden = true
                                self.nextButton.isEnabled = true
                            })
                            self.nextButton.titleLabel?.text = "Next"
                            self.nextButton.backgroundColor = UIColor.litGreen()
                            self.nextButton.isEnabled = true
                            KRProgressHUD.dismiss()
                        } else {
                            UserDefaults.standard.set(self.emailField.text, forKey: DEFAULTS_EMAIL)
                            UserDefaults.standard.set(self.usernameField.text, forKey: DEFAULTS_USERNAME_)
                            let story = UIStoryboard(name: "Onboard", bundle: nil)
                            let controller = story.instantiateViewController(withIdentifier: "passwordViewController")
                            self.navigationController?.pushViewController(controller, animated: true)
                            KRProgressHUD.dismiss()
                        }
                    })

                }
            })
            
        }
    }
 
}

