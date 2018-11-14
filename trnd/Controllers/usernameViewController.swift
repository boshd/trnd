//
//  SignUpViewController1.swift
//  Photograph
//
//  Created by Kareem Arab on 2016-12-29.
//  Copyright © 2016 Kareem Arab. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Parse
import VBFPopFlatButton

class UsernameViewController_nah: UIViewController, UITextFieldDelegate {
    
    // IB Outlets
    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var con: NSLayoutConstraint!
    
    // IB Actions
    @IBAction func nextAction(_ sender: AnyObject) {
        UserDefaults.standard.set(field.text, forKey: DEFAULTS_FULLNAME)
        if let viewController = UIStoryboard(name: "Onboard", bundle: nil).instantiateViewController(withIdentifier: "emailViewController") as? SignUpUserViewController{
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: false)
            }
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.becomeFirstResponder()
        //curvedView.layer.cornerRadius = 10
        UITextField.appearance().tintColor = .white
        nextButton.layer.cornerRadius = 10
        
        field.attributedPlaceholder = NSAttributedString(string: "name",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        nextButton.isEnabled = false
        nextButton.backgroundColor =  UIColor(red:0.64, green:0.20, blue:0.29, alpha:1.0)
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        field.becomeFirstResponder()
    }
    
    @objc func editingChanged(_ textField: UITextField) {
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
    



    
    
}


