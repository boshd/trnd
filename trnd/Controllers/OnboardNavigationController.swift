//
//  OnboardNavigationController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import VBFPopFlatButton

class OnboardNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Color for title of navigation controller
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Color for buttons of navigation controller
        self.navigationBar.tintColor = .white
        // Color of background for navigation controller
        self.navigationBar.backgroundColor = .clear
        // Disable transparency
        //self.navigationBar.translucent = false
        let height: CGFloat = 200 //whatever height you want to add to the existing height
        let bounds = self.navigationBar.bounds
        self.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 300)
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 18)! ]
        
        let backButton = UIBarButtonItem(title: "< back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 18)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
        

    }
    
}
