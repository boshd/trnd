//
//  AppDelegate.swift
//  trnd
//
//  Created by Kareem Arab on 2018-11-13.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import SwiftyGiphy

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
        //Sp2V7VQnfKwNZLnzKhW6CcYPkh0UOmgq
        SwiftyGiphyAPI.shared.apiKey = "Sp2V7VQnfKwNZLnzKhW6CcYPkh0UOmgq"
        
        UINavigationBar.appearance().barTintColor = UIColor.offBlack()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        do
        {
            try reachability.startNotifier()
        }
        catch
        {
            print( "ERROR: Could not start reachability notifier." )
        }
        
        return true
    }
    
    class func sharedAppDelegate() -> AppDelegate?
    {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    // Called when the user logs in or signs up in the app, determines which storyboard to present
    func login() {
        NavigationManager.setRootViewController(ofWindow: window)
    }
    func loginFirstTime() {
        NavigationManager.setRootViewControllerFirstTime(ofWindow: window)
    }

}

