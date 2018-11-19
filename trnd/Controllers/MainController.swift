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
import NotificationBannerSwift
import ALCameraViewController

class MainController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trndLabel: UILabel!
    //@IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var leftLabel: UIOutlinedLabel!
    @IBOutlet weak var rightLabel: UIOutlinedLabel!
    @IBOutlet weak var profileLabel: UILabel!
    //@IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    //@IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    //@IBOutlet weak var transView: UIView!
    @IBOutlet weak var theFaintLine: UIView!
    
    // Props
    //let banner = StatusBarNotificationBanner(title: "dfdf", style: .success)
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

        self.scrollView.delegate = self
        let point = CGPoint(x: CGFloat(self.scrollView.frame.size.width), y: CGFloat(0))
        self.scrollView.setContentOffset(point, animated: false)

        view.bringSubviewToFront(bottomView)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        page1 = storyboard.instantiateViewController(withIdentifier: "FeedViewControllerNAV")
        page2 = storyboard.instantiateViewController(withIdentifier: "skView")
        page3 = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerNAV")
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let r_os = scrollView.contentOffset.x
        let f_os = (r_os - 187.5) / (0 - 187.5)
        let j_os = (r_os - 0) / (187.5 - 0)
        let s_os = (r_os - 562.5) / (750 - 562.5)
        let left_right_first_in_trans  = (r_os - 187.5) / (375 - 187.5)
        let left_right_first_out_trans = (r_os - 562.5) / (375 - 562.5)
        let left_right_second_in_trans = (r_os - 562.5) / (750 - 562.5)
        let offset = scrollView.contentOffset.x
        print(offset)
        if offset == 0 {
            leftLabel.text = ""
            rightLabel.text = ""
            topView.backgroundColor = .white
            theFaintLine.backgroundColor = UIColor.clear
            
            feedLabel.textColor = UIColor.offBlack()
            recordButton.progressColor = UIColor.offWhite()
            profileLabel.textColor = UIColor.offWhite()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disappeared"), object: nil)
        } else if offset > 0 && offset < 375 {
            leftLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
            leftLabel.textColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha: left_right_first_in_trans)
            leftLabel.text = String.fontAwesomeIcon("caretsquareoup")
            leftLabel.outlineColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha: left_right_first_in_trans)
            rightLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
            rightLabel.textColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha: left_right_first_in_trans)
            rightLabel.text = String.fontAwesomeIcon("fire")
            rightLabel.outlineColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha: left_right_first_in_trans)
            
            if offset > 187.5 {
                feedLabel.textColor = UIColor.offWhite()
                recordButton.progressColor = UIColor.offBlack()
                profileLabel.textColor = UIColor.offWhite()
            }
            
            topView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: f_os)
            bottomView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: f_os)
            theFaintLine.backgroundColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:j_os)
        } else if offset == 375 {
            feedLabel.textColor = UIColor.offWhite()
            recordButton.progressColor = UIColor.offBlack()
            profileLabel.textColor = UIColor.offWhite()
            var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
        } else if offset > 375 && offset < 750 {
            leftLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
            leftLabel.textColor = UIColor(red:0.89, green:0.90, blue:0.91, alpha: left_right_first_out_trans)
            leftLabel.text = String.fontAwesomeIcon("caretsquareoup")
            rightLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
            rightLabel.textColor = UIColor(red:0.89, green:0.90, blue:0.91, alpha: left_right_first_out_trans)
            rightLabel.text = String.fontAwesomeIcon("fire")
            if offset > 562.5 && offset < 750 {
                rightLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
                rightLabel.textColor = UIColor(red:1.00, green:0.31, blue:0.45, alpha:left_right_second_in_trans)
                rightLabel.text = String.fontAwesomeIcon("grav")
                feedLabel.textColor = UIColor.offWhite()
                recordButton.progressColor = UIColor.offWhite()
                profileLabel.textColor = UIColor.offBlack()
            }
            topView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: s_os)
            bottomView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: s_os)
            theFaintLine.backgroundColor = UIColor(red:0.67, green:0.67, blue:0.67, alpha:left_right_first_out_trans)
        } else if offset >= 750 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disappeared"), object: nil)
            leftLabel.text = ""
            rightLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
            rightLabel.textColor = UIColor.litPink()
            rightLabel.text = String.fontAwesomeIcon("grav")
            theFaintLine.backgroundColor = UIColor.clear
        }
    }
    
    func upload() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PreviewViewController")
        present(controller, animated: false, completion: nil)
//        var libraryEnabled: Bool = true
//        var croppingEnabled: Bool = true
//        var allowResizing: Bool = true
//        var allowMoving: Bool = true
//        var croppingParameters: CroppingParameters {
//            return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: CGSize(width: 60, height: 60))
//        }
//        /// Provides an image picker wrapped inside a UINavigationController instance
//        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
//            // Do something with your image here.
//            // If cropping is enabled this image will be the cropped version
//
//            self?.dismiss(animated: true, completion: nil)
//        }
//        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    func start() {
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
    
    func setupGesturesAndTargets() {
        let feedGR = UITapGestureRecognizer(target: self, action: #selector(MainController.goToFeed))
        feedLabel.isUserInteractionEnabled = true
        feedLabel.addGestureRecognizer(feedGR)
        
        let profileGR = UITapGestureRecognizer(target: self, action: #selector(MainController.goToProfile))
        profileLabel.isUserInteractionEnabled = true
        profileLabel.addGestureRecognizer(profileGR)
        
        //let notifGR = UITapGestureRecognizer(target: self, action: #selector(MainController.NOTIF))
        //notificationLabel.isUserInteractionEnabled = true
        //notificationLabel.addGestureRecognizer(notifGR)
        
        let trndGR = UITapGestureRecognizer(target: self, action: #selector(MainController.TRND))
        trndLabel.isUserInteractionEnabled = true
        trndLabel.addGestureRecognizer(trndGR)
        
        let leftGR = UITapGestureRecognizer(target: self, action: #selector(MainController.leftPressed))
        leftLabel.isUserInteractionEnabled = true
        leftLabel.addGestureRecognizer(leftGR)
        
        let rightGR = UITapGestureRecognizer(target: self, action: #selector(MainController.rightPressed))
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(rightGR)
        
        // Add reachability observer
        if let reachability = AppDelegate.sharedAppDelegate()?.reachability {
            NotificationCenter.default.addObserver( self, selector: #selector( self.reachabilityChanged ),name: ReachabilityChangedNotification, object: reachability )
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToFeed), name: NSNotification.Name(rawValue: "goToFeed"), object: nil)
        
        recordButton.addTarget(self, action: #selector(MainController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MainController.stop), for: .touchUpInside)
        

    }
    
    func setupRecordButton() {
        // set up recorder button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        //recordButton.center = self.bottomView.center
        recordButton.progressColor = UIColor.litPink()
        //recordButton.buttonColor = UIColor.offWhite()
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(MainController.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(MainController.stop), for: .touchUpInside)
        recordButton.center.x = self.view.center.x
        bottomView.addSubview(recordButton)
    }
    
    func setupTopBar() {
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowOpacity = 0.1
        topView.layer.shadowOffset = CGSize(width: 0, height: 7)
        topView.layer.shadowRadius = 6
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
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var frame: CGRect = scrollView.frame
        let width: CGFloat = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
//        if page == 0 {
//            feedLabel.textColor = UIColor.offBlack()
//            recordButton.progressColor = UIColor.offWhite()
//            profileLabel.textColor = UIColor.offWhite()
//        } else if page == 1 {
//            feedLabel.textColor = UIColor.offWhite()
//            recordButton.progressColor = UIColor.offBlack()
//            profileLabel.textColor = UIColor.offWhite()
//        } else if page == 2 {
//            feedLabel.textColor = UIColor.offWhite()
//            recordButton.progressColor = UIColor.offWhite()
//            profileLabel.textColor = UIColor.offBlack()
//        }
    }
    
    @objc func leftPressed(sender:UIGestureRecognizer) {
        if leftLabel.text == String.fontAwesomeIcon("caretsquareoup") {
            upload()
        } else if leftLabel.text == "" {
            //
        }
    }
    
    @objc func rightPressed(sender:UIGestureRecognizer) {
        if rightLabel.text == String.fontAwesomeIcon("fire") {
            print("flip camera plz")
        } else if rightLabel.text == String.fontAwesomeIcon("grav") {
            NOTIF(sender: .init())
        } else {
            //
        }
    }
    
    @objc private func reachabilityChanged( notification: NSNotification ) {
        guard let reachability = notification.object as? Reachability else
        {
            return
        }
        
        if reachability.isReachable
        {
            if reachability.isReachableViaWiFi
            {
                print("Reachable via WiFi")
                //banner.dismiss()
            }
            else
            {
                print("Reachable via Cellular")
                //banner.dismiss()
            }
        }
        else
        {
            //banner.show()
        }
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
        //recordButton.buttonColor = UIColor.offBlack()
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
            //recordButton.buttonColor = UIColor.offBlack()
            profileLabel.textColor = UIColor.offWhite()
            frame.origin.x = frame.size.width * 1
            frame.origin.y = 0
            scrollView.scrollRectToVisible(frame, animated: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pleaseRecord"), object: nil)
            //self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(MainController.updateProgress), userInfo: nil, repeats: true)
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
//        var frame: CGRect = scrollView.frame
//        let width: CGFloat = scrollView.frame.size.width
//        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
//        
//        if page != 1 {
//            frame.origin.x = frame.size.width * 1
//            frame.origin.y = 0
//            scrollView.scrollRectToVisible(frame, animated: true)
//        } else {
//            self.progressTimer.invalidate()
//        }
    }
    
}

class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = UIColor.clear
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
