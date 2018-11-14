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
        self.nextButton.backgroundColor =  UIColor.offPink()
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
        
        //self.navigationItem.hidesBackButton = false
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Basdck", style: .plain, target: nil, action: nil)
        let yourBackImage = UIImage(from: .fontAwesome, code: "angleleft", textColor: .white, backgroundColor: .clear, size: CGSize(width: 50, height: 50))
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
            self.nextButton.backgroundColor = UIColor.offPink()
        default:
            //print("here")
            //errLabel.text = ""
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor.offPink()
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
                    self.nextButton.backgroundColor =  UIColor.offPink()
                    print("username taken")
                } else {
                    self.nextButton.backgroundColor =  UIColor.litPink()
                    self.errLabel.isHidden = true
                    self.nextButton.isEnabled = true
                }
            })
        }
    }
    
    @objc func emailChanged() {
        self.nextButton.backgroundColor =  UIColor.litPink()
        self.nextButton.isEnabled = true
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            errLabel.text = "field plz."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offPink()
        case EmailValidator.invalidEmail(emailField.text!):
            errLabel.text = "That doesn't seem like a correct email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor = UIColor.offPink()
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
                    self.nextButton.backgroundColor =  UIColor.litPink()
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
            //nextField.becomeFirstResponder()
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
        nextButton.backgroundColor =  .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Methods
    func GO() {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(emailField, usernameField):
            errLabel.text = "Email can't be empty"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            }
        case EmailValidator.invalidEmail(emailField.text!):
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
            self.username_query_isGood = false
            self.email_query_isGood = false
            
            let username_query: PFQuery = PFUser.query()!
            username_query.whereKey("username", equalTo: usernameField.text!)
            username_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.nextButton.setTitle("next", for: .normal)
                    
                    self.errLabel.text = "username taken"
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.errLabel.isHidden = true
                        self.nextButton.isEnabled = true
                    })
                    self.username_query_isGood = false
                } else {
                    self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    self.username_query_isGood = true
                }
            })
            
            let email_query: PFQuery = PFUser.query()!
            email_query.whereKey("email", equalTo: self.emailField.text!)
            email_query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.nextButton.setTitle("next", for: .normal)
                    
                    self.errLabel.text = "Email taken. Try signing in."
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        self.errLabel.isHidden = true
                        self.nextButton.isEnabled = true
                    })
                    self.email_query_isGood = false
                } else {
                    self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    self.email_query_isGood = true
                }
            })
            
            if username_query_isGood && email_query_isGood {
                UserDefaults.standard.set(self.emailField.text, forKey: DEFAULTS_EMAIL)
                UserDefaults.standard.set(self.usernameField.text, forKey: DEFAULTS_USERNAME_)
                let story = UIStoryboard(name: "Onboard", bundle: nil)
                let controller = story.instantiateViewController(withIdentifier: "passwordViewController")
                navigationController?.pushViewController(controller, animated: true)
                print("arriveeded")
            } else {
                // dont do anything
                print("wont go no where")
            }
            
        }
    }
 
}

