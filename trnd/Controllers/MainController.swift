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
import Parse
import RecordButton

class MainController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trndLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    //@IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // Props
    var page1: UIViewController!
    var page2: UIViewController!
    var page3: UIViewController!
    var pages = [UIViewController]()
    var recordButton : RecordButton!
    var progressTimer : Timer!
    var progress : CGFloat! = 0
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTopBar()
        setupBottomBar()
        setupGesturesAndTargets()
        //setupRecordButton()
        //setupButtonAnimation()
        start()
        
        // stuff
        
        self.scrollView.delegate = self
        let point = CGPoint(x: CGFloat(self.scrollView.frame.size.width), y: CGFloat(0))
        self.scrollView.setContentOffset(point, animated: false)

        view.bringSubviewToFront(bottomView)
        //view.bringSubviewToFront(topView)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foto_storyboard = UIStoryboard(name: "Cam", bundle: nil)
        page1 = storyboard.instantiateViewController(withIdentifier: "FeedViewControllerNAV")
        page2 = foto_storyboard.instantiateViewController(withIdentifier: "CamViewControllerNAV")
        page3  = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerNAV")
        
        // Horizontal ScrollView
        page3.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(page3);
        self.scrollView!.addSubview(page3.view);
        page3.didMove(toParent: self);
        
        page2.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(page2);
        self.scrollView!.addSubview(page2.view);
        page2.didMove(toParent: self);
        
        page1.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(page1);
        self.scrollView!.addSubview(page1.view);
        page1.didMove(toParent: self);

        pages = [page1,page2,page3]
        let views: [String: UIView] = ["view": view, "page1": page1.view, "page2": page2.view, "page3": page3.view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page1(==view)]|", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints+horizontalConstraints)

    }
    
    func start() {
        feedLabel.textColor = UIColor.litGreen()
        recordButton.progressColor = UIColor.offWhite()
        //recordButton.buttonColor = UIColor.offWhite()
        profileLabel.textColor = UIColor.offWhite()
        
        index = 0
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 0
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupGesturesAndTargets() {
        let feedGR = UITapGestureRecognizer(target: self, action: #selector(MainController.goToFeed))
        feedLabel.isUserInteractionEnabled = true
        feedLabel.addGestureRecognizer(feedGR)
        
        let profileGR = UITapGestureRecognizer(target: self, action: #selector(MainController.goToProfile))
        profileLabel.isUserInteractionEnabled = true
        profileLabel.addGestureRecognizer(profileGR)
        
        let notifGR = UITapGestureRecognizer(target: self, action: #selector(MainController.NOTIF))
        notificationLabel.isUserInteractionEnabled = true
        notificationLabel.addGestureRecognizer(notifGR)
        
        let trndGR = UITapGestureRecognizer(target: self, action: #selector(MainController.TRND))
        trndLabel.isUserInteractionEnabled = true
        trndLabel.addGestureRecognizer(trndGR)
        
        recordButton.addTarget(self, action: #selector(MainController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MainController.stop), for: .touchUpInside)
        

    }
    
    func setupRecordButton() {
        
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        //recordButton.center = self.bottomView.center
        recordButton.progressColor = UIColor.litPink()
        recordButton.buttonColor = UIColor.offWhite()
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(MainController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MainController.stop), for: .touchUpInside)
        recordButton.center.x = self.view.center.x
        bottomView.addSubview(recordButton)
        
    }
    
    func setupTopBar() {
        notificationLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 40.0)
        notificationLabel.textColor = UIColor.litPink()
        notificationLabel.text = String.fontAwesomeIcon("grav")
    }
    
    func setupBottomBar() {
        
        feedLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
        feedLabel.textColor = UIColor.offWhite()
        feedLabel.text = String.fontAwesomeIcon("bolt")
        
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 5, width: 50, height: 50))
        recordButton.progressColor = UIColor.offWhite()
        recordButton.buttonColor = UIColor.offWhite()
        recordButton.closeWhenFinished = false
        //recordButton.center.y = self.bottomView.center.y
        recordButton.center.x = self.view.center.x
        bottomView.addSubview(recordButton)
        
        profileLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
        profileLabel.textColor = UIColor.offWhite()
        profileLabel.text = String.fontAwesomeIcon("user")
        
        bottomView.layer.shadowColor = UIColor.gray.cgColor
        bottomView.layer.shadowOpacity = 0.1
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -7)
        bottomView.layer.shadowRadius = 6
    }
    
    func setupButtonAnimation() {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.fromValue = 0.5
        animation.toValue = 1.0
        animation.duration = 0.6
        //Set the speed of the layer to 0 so it doesn't animate until we tell it to
        //self.cameraLabel.layer.speed = 0.0;
        //self.cameraLabel.layer.add(animation, forKey: "transform");
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var frame: CGRect = scrollView.frame
        let width: CGFloat = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        
        if page == 0 {
            feedLabel.textColor = UIColor.offBlack()
            recordButton.progressColor = UIColor.offWhite()
            //recordButton.buttonColor = UIColor.offWhite()
            profileLabel.textColor = UIColor.offWhite()
        } else if page == 1 {
            feedLabel.textColor = UIColor.offWhite()
            recordButton.progressColor = UIColor.offBlack()
            //recordButton.buttonColor = .white
            profileLabel.textColor = UIColor.offWhite()
        } else if page == 2 {
            feedLabel.textColor = UIColor.offWhite()
            recordButton.progressColor = UIColor.offWhite()
            //recordButton.buttonColor = UIColor.offWhite()
            profileLabel.textColor = UIColor.offBlack()
        }
            
        /*
        print("WE REACHED AND THIS IS us")
        let screenSize = self.view.bounds.size
        if let btn =  self.cameraLabel
        {
            var factor:CGFloat = 1.0
            factor = scrollView.contentOffset.x / screenSize.width
            if factor > 1
            {
                factor = 2 - factor
            }
            print("WE REACHED AND THIS IS FACTOR: \(factor)")
            //This will change the size
            let timeOffset = CFTimeInterval(1-factor)
            btn.layer.timeOffset = timeOffset
        }*/
    }
    
    @objc func TRND(sender:UITapGestureRecognizer) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
        self.present(controller!, animated: true, completion: nil)
    }
    
    @objc func NOTIF(sender:UITapGestureRecognizer) {
        //let controller = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")
        //self.present(controller!, animated: true, completion: nil)
        
        
        let logOutAction = UIAlertAction(title: "Logout", style: .default) { (action: UIAlertAction) in
            PFUser.logOutInBackground { (error: Error?) in
                if error != nil {
                    print(error.debugDescription)
                }
                UserDefaults.standard.removeObject(forKey: DEFAULTS_USERNAME)
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.login()
            }
        }
        
        let deleteAction = UIAlertAction(title: "Delete account", style: .default) { (action: UIAlertAction) in
            //
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(logOutAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func goToFeed(sender:UITapGestureRecognizer) {
        
        feedLabel.textColor = UIColor.offBlack()
        recordButton.progressColor = UIColor.offWhite()
        //recordButton.buttonColor = UIColor.offWhite()
        profileLabel.textColor = UIColor.offWhite()
        
        index = 0
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 0
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc func goToCam(sender:UITapGestureRecognizer) {
        
        feedLabel.textColor = UIColor.offWhite()
        recordButton.progressColor = UIColor.offBlack()
        //recordButton.buttonColor = .white
        profileLabel.textColor = UIColor.offWhite()
        
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 1
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc func goToProfile(sender:UITapGestureRecognizer) {
        
        feedLabel.textColor = UIColor.offWhite()
        recordButton.progressColor = UIColor.offWhite()
        //recordButton.buttonColor = UIColor.offWhite()
        profileLabel.textColor = UIColor.offBlack()
        
        index = 0
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * 2
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc func record() {
        var frame: CGRect = scrollView.frame
        let width: CGFloat = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        
        if page != 1 {
            feedLabel.textColor = UIColor.offWhite()
            recordButton.progressColor = .red
            //recordButton.buttonColor = UIColor.litGreen()
            profileLabel.textColor = UIColor.offWhite()
            frame.origin.x = frame.size.width * 1
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        } else {
            self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MainController.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateProgress() {
        
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        
        progress = progress + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(progress)
        
        if progress >= 1 {
            progressTimer.invalidate()
        }
        
    }
    
    @objc func stop() {
        var frame: CGRect = scrollView.frame
        let width: CGFloat = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        
        if page != 1 {
            frame.origin.x = frame.size.width * 1
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        } else {
            self.progressTimer.invalidate()
        }
        
    }
    
    
    
}
