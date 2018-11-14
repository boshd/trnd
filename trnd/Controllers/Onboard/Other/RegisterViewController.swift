//
//  SignUpController.swift
//  Photograph
//
//  Created by Kareem Arab on 2018-02-02.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse
import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Attributes
    var signUpNameViewController: UIViewController!
    var signUpUserViewController: UIViewController!
    var viewControllers: [UINavigationController]!
    var selectedIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        
        signUpNameViewController = storyboard.instantiateViewController(withIdentifier: "SignUpNameViewControllerNAV")
        signUpUserViewController = storyboard.instantiateViewController(withIdentifier: "SignUpUserViewControllerNAV")
        
        viewControllers = [
            signUpNameViewController as! UINavigationController,
            signUpUserViewController as! UINavigationController
        ]
        
        self.addChild(signUpUserViewController);
        self.scrollView!.addSubview(signUpUserViewController.view);
        signUpUserViewController.didMove(toParent: self);
        
        self.addChild(signUpNameViewController);
        self.scrollView!.addSubview(signUpNameViewController.view);
        signUpNameViewController.didMove(toParent: self);
        
        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        var adminFrame :CGRect = signUpNameViewController.view.frame;
        adminFrame.origin.x = adminFrame.width;
        signUpUserViewController.view.frame = adminFrame;
        
        // 4) Finally set the size of the scroll view that contains the frames
        let scrollWidth: CGFloat  = 2 * self.view.frame.width
        let scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSize(width: scrollWidth, height: scrollHeight);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}
