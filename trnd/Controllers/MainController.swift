//
//  MainController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import NotificationCenter

class MainController: UIViewController {
    
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var notificationsButton: UIButton!
    
    // Declarations
    var feedViewController: UIViewController!
    var camViewController: UIViewController!
    var profileViewController: UIViewController!
    var index = 0
    
    // IBActions
    @IBAction func notificationsAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func gifButtonPressed(_ sender: Any) {
        //let controller = storyboard?.instantiateViewController(withIdentifier: "TheCameraViewController")
        //self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func giftAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    
    // LIFE CYCLE
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons
//        self.feedButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        self.feedButton.setTitle(String.fontAwesomeIcon(name: .home), for: .normal)
//        self.feedButton.tintColor = UIColor.brown
//        self.cameraButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        self.cameraButton.setTitle(String.fontAwesomeIcon(name: .camera), for: .normal)
//        self.profileButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        self.profileButton.setTitle(String.fontAwesomeIcon(name: .userAlt), for: .normal)
//        self.notificationsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        self.notificationsButton.setTitle(String.fontAwesomeIcon(name: .bell), for: .normal)
        
        let point = CGPoint(x: CGFloat(self.scrollView.frame.size.width), y: CGFloat(0))
        self.scrollView.setContentOffset(point, animated: false)
        barView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        view.bringSubviewToFront(barView)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foto_storyboard = UIStoryboard(name: "Cam", bundle: nil)
        feedViewController      = storyboard.instantiateViewController(withIdentifier: "FeedViewControllerNAV")
        camViewController = foto_storyboard.instantiateViewController(withIdentifier: "CamViewControllerNAV")
        profileViewController   = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerNAV")
        
        let ViewController = [
            feedViewController      as! UINavigationController,
            camViewController       as! UINavigationController,
            profileViewController   as! UINavigationController
        ]
        
        // Horizontal ScrollView
        self.addChild(profileViewController);
        self.scrollView!.addSubview(profileViewController.view);
        profileViewController.didMove(toParent: self);
        
        self.addChild(camViewController);
        self.scrollView!.addSubview(camViewController.view);
        camViewController.didMove(toParent: self);
        
        self.addChild(feedViewController);
        self.scrollView!.addSubview(feedViewController.view);
        feedViewController.didMove(toParent: self);

        var adminFrame :CGRect = feedViewController.view.frame;
        adminFrame.origin.x = adminFrame.width;
        camViewController.view.frame = adminFrame;
        
        var CFrame :CGRect = camViewController.view.frame;
        CFrame.origin.x = 2*CFrame.width;
        profileViewController.view.frame = CFrame;

        let scrollWidth: CGFloat  = 3 * self.view.frame.width
        let scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSize(width: scrollWidth, height: scrollHeight);
    }
    
    func start() {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 1
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func goToFeed(_ sender: Any) {
        index = 0
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 0
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func goToTrans(_ sender: Any) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 1
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        index = 0
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 2
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }

    func presentPreview() -> Void {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController")
        present(controller!, animated: false, completion: nil)
    }
    
}
