//
//  UsernameViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import VBFPopFlatButton

class UsernameViewController: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        GO()
    }
    
    @IBAction func backAction(_ sender: Any) {
        //dismiss(animated: false, completion: nil)
    }
    
    // LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.becomeFirstResponder()
        
        
        UITextField.appearance().tintColor = .white
        nextButton.layer.cornerRadius = 10
        
        //field.attributedPlaceholder = NSAttributedString(string: "username",
                                                                 //attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.indicator.isHidden = true
        indicator.color = UIColor.fabishPink()
        
        nextButton.isEnabled = false
        nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        field.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(UsernameViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UsernameViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    @objc func usernameChanged() {
        switch true {
        case UsernameValidator.usernameInvalidLength(field.text!):
            errLabel.text = "Username must be longer."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        default:
            nextButton.isEnabled = false
            self.nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
            let query: PFQuery = PFUser.query()!
            query.whereKey("username", equalTo: field.text!)
            query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
                if object != nil {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.nextButton.setTitle("next", for: .normal)
                    
                    self.errLabel.text = "Username taken."
                    
                    self.errLabel.isHidden  = false
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
                } else {
                    self.nextButton.backgroundColor =  UIColor.white
                    self.errLabel.isHidden = true
                    self.nextButton.isEnabled = true
                }
            })
            
            
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    // Methods
    func GO() {
        
        switch true {
        case TextFieldValidator.emptyFieldExists(field):
            errLabel.text = "pick username plz."
            errLabel.isHidden  = false
            nextButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.errLabel.isHidden = true
                self.nextButton.isEnabled = true
            })
        case UsernameValidator.usernameInvalidLength(field.text!):
            errLabel.text = "Username has to be a bit longer."
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
            query.whereKey("username", equalTo: field.text!)
            query.getFirstObjectInBackground(block: {(object: PFObject?, error: Error?) -> Void in
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
                } else {
                    self.nextButton.tintColor = UIColor(red:0.71, green:0.22, blue:0.33, alpha:1.0)
                    UserDefaults.standard.set(self.field.text, forKey: DEFAULTS_USERNAME_)
                    
                }
            })
            
            
        }
    }

    
    
}


