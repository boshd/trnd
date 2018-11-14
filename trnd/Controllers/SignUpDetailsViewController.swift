//
//  SignUpDetailsViewController.swift
//  Photograph
//
//  Created by Kareem Arab on 8/6/16.
//  Copyright © 2016 kareemarab. All rights reserved.
//

import UIKit
import Parse

class SignUpDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var selectedImage: CircleImageView!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var nameField: OnboardTextField!
    @IBOutlet weak var usernameField: OnboardTextField!
    @IBOutlet weak var passwordField: OnboardTextField!
    
    @IBOutlet weak var signUpButton: OnboardButton!
    
    // MARK: - Properties
    
   // var email: String?
    var fieldObserver: OnboardFieldObserver?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboardFieldObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods: Internal
    
    /// Dismisses the keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Dismisses keyboard when touch occurs in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    /// Returns a light statusbar style by default
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Methods: Private
    
    /// Setup TextFieldDelegate
    fileprivate func setupOnboardFieldObserver() {
        fieldObserver = OnboardFieldObserver(observer: self, textFields: usernameField, passwordField)
        fieldObserver?.managedButton = signUpButton
    }
    
    /// Creates a PFFile for an image and compresses
    func createFileFrom(image: UIImage?, withCompression compression: CGFloat) -> PFFile? {
        let image = image ?? UIImage(named: "PlaceholderAvatar")!
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        return PFFile(name: "avatar.jpeg", data: data)
    }
    
    /// Create account for user
    func createUser() -> PFUser? {
        //guard let email = email else { return nil }
        
        let user = PFUser()
        user.username = usernameField.text!
        user.password = passwordField.text!
        //user.email = email
        
        if let name = nameField.text {
            user[QueryKey.FullName] = name
        }

        if let imageFile = createFileFrom(image: selectedImage.image, withCompression: 0.5) {
            user[QueryKey.Avatar] = imageFile
        }
        return user
    }
    
    /// Sign up user
    func signUpUser(_ user: PFUser) {
        user.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                UserDefaults.standard.set(user.username!, forKey: DEFAULTS_USERNAME)
            } else if let error = error {
                print(error)
                ErrorAlertService.displayAlertFor(.AccountCreation, withPresenter: self)
            }
        }
    }
    
    /// Image picker finished selecting image
    func imagePickerFinished(_ notification: Foundation.Notification) {
        if let image = notification.object as? UIImage {
            //photoLabel.hidden = true
            //plusLabel.hidden = true
            selectedImage.image = image
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addPhotoTapped(_ sender: AnyObject) {
        selectedImage.image = UIImage(named: "me.JPG")
    }
    
    @IBAction func signUpPressed(_ sender: AnyObject) {
        switch true {
        case TextFieldValidator.emptyFieldExists(usernameField, passwordField):
            ErrorAlertService.displayAlertFor(.EmptyField, withPresenter: self)
            
        case UsernameValidator.invalidCharactersIn(username: usernameField.text!):
            ErrorAlertService.displayAlertFor(.InvalidUsername, withPresenter: self)
            
        case UsernameValidator.usernameInvalidLength(usernameField.text!):
            ErrorAlertService.displayAlertFor(.UsernameLength, withPresenter: self)
            
        case PasswordValidator.passwordInvalidLength(passwordField.text!):
            ErrorAlertService.displayAlertFor(.PasswordLength, withPresenter: self)
            
        case PasswordValidator.passwordTooWeak(passwordField.text!):
            ErrorAlertService.displayAlertFor(.InvalidPassword, withPresenter: self)
        default:
            guard let user = createUser() else { break }
            signUpUser(user)
        }
    }
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        NavigationManager.showSignInViewController(withPresenter: self)
    }
}
