//
//  NavigationControllerViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Color for title of navigation controller
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Color for buttons of navigation controller
        self.navigationBar.tintColor = UIColor.black
        // Color of background for navigation controller
        self.navigationBar.backgroundColor = UIColor.clear
        // Disable transparency
        //self.navigationBar.translucent = false
        
        self.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 18)! ]
        //self.navigationBar.frame = CGRect(x: 0, y: 0, width: 320, height: 94)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()

    }
    
}
