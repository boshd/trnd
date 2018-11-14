//
//  WelcomeViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import VBFPopFlatButton

class WelcomeViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var welcomeToGift: UILabel!
    
    // IB Actions
    @IBAction func signUpButton(_ sender: UIButton) { // Touch up
        let story = UIStoryboard(name: "Onboard", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "usernameEmailViewController")
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func signInButton(_ sender: AnyObject) {
        let story = UIStoryboard(name: "Onboard", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "SignInViewController")
        present(controller, animated: false, completion: nil)
    }
    
    // 
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TRND"
        //curvedView.layer.cornerRadius = 10
        self.signUpButton.layer.cornerRadius = 10
        //self.signUpButtonView.layer.cornerRadius = 10
        self.signInButton.layer.cornerRadius = 4
        self.signUpButton.clipsToBounds = true
        self.signUpButton.setTitleColor(UIColor.white, for: .highlighted)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

class BackgroundHighlightedButton: UIButton {
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
            super.isHighlighted = newValue
        }
    }
}
