//
//  AppDelegate.swift
//  trnd
//
//  Created by Kareem Arab on 2018-11-13.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var networkStatus: Reachability.NetworkStatus?
    var reachability = Reachability()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Check which storyboard to display
        login()
        
        // Setup Parse Server
        ParseServer.singleInstance.initializeParseServer()
        
        return true
    }
    
    // Called when the user logs in or signs up in the app, determines which storyboard to present
    func login() {
        NavigationManager.setRootViewController(ofWindow: window)
    }
    func loginFirstTime() {
        NavigationManager.setRootViewControllerFirstTime(ofWindow: window)
    }

}

