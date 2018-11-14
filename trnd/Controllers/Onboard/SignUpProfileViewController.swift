//
//  SignUpProfileViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ALCameraViewController

class SignUpProfileViewController: UIViewController {
    
    // IB Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var usernameLabel2: UILabel!
    
    // IB Actions
    @IBAction func close(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        guard let currentUser2 = PFUser.current() else { return }
        
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //appDelegate?.login()
        
        if profileImage == nil {
            let currentUser = PFUser.current()
            print("No image uploaded.")

            guard let currentUser2 = PFUser.current() else { return }
            if let image = UIImage(named: "chill.jpg"), let avatarData = image.jpegData(compressionQuality: 0.5) {
                let file = PFFile(name: "avatar", data: avatarData)
                currentUser2[QueryKey.Avatar] = file
            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.login()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
                let controller = MainController()
                controller.storyboard
            }
            
        }else{
            guard let currentUser = PFUser.current() else { return }
            if let image = profileImage.image, let avatarData = image.jpegData(compressionQuality: 0.5) {
                let file = PFFile(name: "avatar", data: avatarData)
                currentUser[QueryKey.Avatar] = file
            }
            UserService.saveUserDetails(currentUser) { (success: Bool) in
                if success {
                    print("saved new pp")
                } else {
                    ErrorAlertService.displayAlertFor(.CouldNotSave, withPresenter: self)
                }
            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.login()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
                let controller = MainController()
                controller.storyboard
            }
            

        }
        
    }
    
    @IBAction func addPhotoAction(_ sender: AnyObject) {
        
        //let croppingEnabled = true
        //let cameraViewController = CameraViewController(croppingParameters: croppingEnabled) { [weak self] image, asset in
            
            //self?.profileImage.image = image
            //self?.addPhotoButton.setImage(nil, for: .normal)
            
            //self?.dismiss(animated: true, completion: nil)
        //}
        
        //present(cameraViewController, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "TRND"
        //self.addPhotoButton.isEnabled = false
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont(name: "Avenir Next", size: 18)! ]
        
        self.doneButton.layer.cornerRadius = 8
        self.doneButton.clipsToBounds = true
        self.picView.layer.cornerRadius = 130/2
        self.picView.clipsToBounds = true
        self.profileImage.layer.cornerRadius = 130/2
        self.profileImage.clipsToBounds = true
        
        let user = PFUser.current()
        let fullname = UserDefaults.standard.string(forKey: DEFAULTS_FULLNAME)

        if let usernameString = user?.object(forKey: "username") as? String {
            self.usernameLabel.text = "Welcome, @\(usernameString)!"
        }
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
