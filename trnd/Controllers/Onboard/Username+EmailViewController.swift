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

class UsernameEmailViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var username_query_isGood: Bool = false
    var email_query_isGood: Bool = false
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var keyboardHeightLayoutConstraint_ind: NSLayoutConstraint?
    @IBOutlet var keyboardHeightLayoutConstraint_viewNscroll: NSLayoutConstraint?
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.becomeFirstResponder()
        self.nextButton.backgroundColor =  UIColor.offGreen()
        self.nextButton.isEnabled = false
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
        indicator.isHidden = false
        hideKeyboardWhenTappedAround()
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

        
        self.indicator.isHidden = true
        indicator.color = UIColor.litPink()
        
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
    
    @objc func usernameChanged() {
        switch true {
        case UsernameValidator.usernameInvalidLength(usernameField.text!):
            errLabel.text = "Username must be longer."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
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
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.nextButton.setTitle("next", for: .normal)
                    
                    self.errLabel.text = "Username taken."
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor =  UIColor.offGreen()
                    self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
                    print("username taken")
                } else {
                    self.emailChanged()
                }
            })
        }
    }
    
    
    
    @objc func emailChanged() {
        self.nextButton.backgroundColor =  UIColor.litGreen()
        self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
        self.nextButton.isEnabled = true
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            errLabel.text = "Something's missing."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
        case EmailValidator.invalidEmail(emailField.text!):
            errLabel.text = "That doesn't seem like a correct email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offGreen()
            self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
        default:
            let queryy: PFQuery = PFUser.query()!
            queryy.whereKey("email", equalTo: self.emailField.text!)
            queryy.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    
                    self.errLabel.text = "Email taken. Perhaps you already have an account? Try signing in."
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    print("reached 2")
                } else {
                    self.nextButton.backgroundColor =  UIColor.litGreen()
                    self.nextButton.setTitleColor(UIColor.offBlack(), for: .normal)
                    self.errLabel.isHidden = true
                    self.nextButton.isEnabled = true
                }
            })
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
    
    func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let habit = usernameField.text, !habit.isEmpty
            else {
                nextButton.isEnabled = false
                nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
                return
        }
        nextButton.isEnabled = true
        //nextButton.backgroundColor =  .white
    }
    
    // Methods
    func GO() {
        nextButton.titleLabel?.text = ""
        nextButton.backgroundColor = UIColor.offGreen()
        nextButton.isEnabled = false
        indicator.isHidden = false
        indicator.startAnimating()
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            self.nextButton.titleLabel?.text = "Next"
            self.nextButton.backgroundColor = UIColor.litGreen()
            self.nextButton.isEnabled = true
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
            errLabel.text = "Email can't be empty"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            }
        case EmailValidator.invalidEmail(emailField.text!):
            self.nextButton.titleLabel?.text = "Next"
            self.nextButton.backgroundColor = UIColor.litGreen()
            self.nextButton.isEnabled = true
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
            errLabel.text = "Please enter a valid email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
//        case UsernameValidator.usernameInvalidLength(usernameField.text!):
//            errLabel.text = "Username has to be a bit longer"
//            errLabel.isHidden  = false
//            nextButton.isEnabled = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                self.errLabel.isHidden = true
//                self.nextButton.isEnabled = true
//            })
        default:
            
            
            let username_query: PFQuery = PFUser.query()!
            username_query.whereKey("username", equalTo: usernameField.text!)
            username_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
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
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                } else {
                    let email_query: PFQuery = PFUser.query()!
                    email_query.whereKey("email", equalTo: self.emailField.text!)
                    email_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                        if object != nil {
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
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
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
                        } else {
                            UserDefaults.standard.set(self.emailField.text, forKey: DEFAULTS_EMAIL)
                            UserDefaults.standard.set(self.usernameField.text, forKey: DEFAULTS_USERNAME_)
                            let story = UIStoryboard(name: "Onboard", bundle: nil)
                            let controller = story.instantiateViewController(withIdentifier: "passwordViewController")
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    })

                }
            })
            
        }
    }
 
}

