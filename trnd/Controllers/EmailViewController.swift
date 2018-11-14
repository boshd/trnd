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

class EmailViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var con: NSLayoutConstraint!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    // LIFE CYCLE
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.becomeFirstResponder()
        curvedView.layer.cornerRadius = 10
        UITextField.appearance().tintColor = .white
        nextButton.layer.cornerRadius = 10
        
        //field.attributedPlaceholder = NSAttributedString(string: "email",
                                                         //attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.indicator.isHidden = true
        indicator.color = UIColor.fabishPink()
        
        //nextButton.isEnabled = false
        //nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        field.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EmailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButton.frame.origin.y == 0{
                self.nextButton.frame.origin.y -= keyboardSize.height
                self.indicator.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.nextButton.frame.origin.y != 0{
                self.nextButton.frame.origin.y += keyboardSize.height
                self.indicator.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func emailChanged() {
     /*
        switch true {
        case TextFieldValidator.emptyFieldExists(field):
            errLabel.text = "email plz."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        case EmailValidator.invalidEmail(field.text!):
            errLabel.text = "That doesn't seem like a correct email"
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        default:
            let queryy: PFQuery = PFUser.query()!
            queryy.whereKey("email", equalTo: self.field.text!)
            queryy.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    
                    self.errLabel.text = "Email taken. Perhaps you already have an account? Try signing in."
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    print("reached 2")
                } else {
                    self.nextButton.backgroundColor =  UIColor.white
                    //self.nextButton.backgroundColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    self.errLabel.isHidden = true
                    self.nextButton.isEnabled = true
                }
            })
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        field.becomeFirstResponder()
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
            let habit = field.text, !habit.isEmpty
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
        case TextFieldValidator.emptyFieldExists(field):
            errLabel.text = "email plz."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        case EmailValidator.invalidEmail(field.text!):
            errLabel.text = "Please enter a valid email."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        default:
    
            let queryy: PFQuery = PFUser.query()!
            queryy.whereKey("email", equalTo: self.field.text!)
            queryy.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                print("reached 1")
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
                    print("reached 2")
                } else {
                    self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    UserDefaults.standard.set(self.field.text, forKey: DEFAULTS_EMAIL)
                    if let viewController = UIStoryboard(name: "Onboard", bundle: nil).instantiateViewController(withIdentifier: "passwordViewController") as? PasswordViewController{
                        if let navigator = self.navigationController {
                            navigator.pushViewController(viewController, animated: false)
                            self.indicator.stopAnimating()
                            self.indicator.isHidden = true
                            self.nextButton.isEnabled = true
                            self.nextButton.setTitle("next", for: .normal)
                        }
                    }
                    print("reached 3")
                }
            })
        }
    }
 
}

