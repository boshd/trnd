//
//  OnboardNavigationController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import VBFPopFlatButton
import SwiftIconFont

class OnboardNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.litGreen(), NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 30)! ]
        
    
        

    }
    
}


