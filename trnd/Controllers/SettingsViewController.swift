//
//  EditViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import VBFPopFlatButton

class SettingsViewController: UIViewController {
    
    // MARK: - IBAction
    @IBAction func coolCancelAction(_ sender: AnyObject) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentContainer: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var coolCancelButton: UIButton!
    
    // MARK: - Properties
    
    var genderPicker: UIPickerView!
    var genders = ["male", "female"]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardObserver.startObservingWillShow(self, selector: #selector(SettingsViewController.showKeyboard))
        retrieverUserInfo()
        roundAvatarImageView()
        setupGenderPicker()
        setupTapToDismiss()
        
        let popFlatButton = VBFPopFlatButton(frame: CGRect(x: CGFloat(200), y: CGFloat(150), width: CGFloat(30), height: CGFloat(30)), buttonType: FlatButtonType.buttonMenuType,
                                             buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: true)
        popFlatButton?.tintColor = UIColor.fabishPink()
        popFlatButton?.addTarget(self, action: #selector(SettingsViewController.coolCancelAction(_:)), for: UIControl.Event.touchUpInside)
        let collapseButton = UIBarButtonItem(customView: popFlatButton!)
        
        self.navigationItem.leftBarButtonItem = collapseButton
        
        
    }
    
    // MARK: - Methods
    
    // MARK: - User Information
    
    /// Retrives and sets the current users information in the appropriate fields
    func retrieverUserInfo() {
        guard let currentUser = PFUser.current() else { return }
        
        UserService.getAvatarImgForUser(currentUser) { (image: UIImage) in
            DispatchQueue.main.async {
                self.avatarImage.image = image
            }
        }
        
        self.fullNameField.text = currentUser.value(forKey: QueryKey.FullName) as? String
        //self.usernameField.text = currentUser.username
        self.websiteField.text = currentUser.value(forKey: QueryKey.Website) as? String
        self.bioTextView.text = currentUser.value(forKey: QueryKey.Bio) as? String
        self.emailField.text = currentUser.email
        self.phoneNumberField.text = currentUser.value(forKey: QueryKey.Telephone) as? String
        self.genderField.text = currentUser.value(forKey: QueryKey.Gender) as? String
    }
    
    /// Updates the users information in database
    func updateUserInformation() {
        
        guard let currentUser = PFUser.current() else { return }
        //currentUser.username = usernameField.text
        currentUser.email = emailField.text
        currentUser[QueryKey.Website] = websiteField.text
        currentUser[QueryKey.FullName] = fullNameField.text
        currentUser[QueryKey.Bio] = bioTextView.text ?? ""
        currentUser[QueryKey.Telephone] = phoneNumberField.text ?? ""
        currentUser[QueryKey.Gender] = genderField.text ?? ""
        
        if let image = avatarImage.image, let avatarData = image.jpegData(compressionQuality: 0.5) {
            let file = PFFile(name: "avatar", data: avatarData)
            currentUser[QueryKey.Avatar] = file
        }
        
        UserService.saveUserDetails(currentUser) { (success: Bool) in
            if success {
                self.endKeyboardObservers()
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorAlertService.displayAlertFor(.CouldNotSave, withPresenter: self)
            }
        }
    }
    
    // MARK: - Keyboard Management
    
    /// Scroll up the scroll view when keyboard is shown
    @objc func showKeyboard(_ notification: Foundation.Notification) {
        let keyboardFrameSize = (((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        let keyboardHeight = keyboardFrameSize.height
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.frame.size.height -= keyboardHeight
        }) 
        KeyboardObserver.endObservingWillShow(self)
        //KeyboardObserver.startObservingWillHide(self, selector: #selector(SettingsViewController.hideKeyboard))
    }
    
    /// Scroll down the scroll view when the keyboard hides
    func hideKeyboard(_ notification: Foundation.Notification) {
        let keyboardFrameSize = (((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        let keyboardHeight = keyboardFrameSize.height
        scrollView.frame.size.height += keyboardHeight
        KeyboardObserver.endObservingWillHide(self)
        KeyboardObserver.startObservingWillShow(self, selector: #selector(SettingsViewController.showKeyboard))
    }
    
    /// Ends all keyboard observers
    func endKeyboardObservers() {
        KeyboardObserver.endObservingWillHide(self)
        KeyboardObserver.endObservingWillShow(self)
    }
    
    /// Sets a tap gesture on scroll view to dismiss keyboard
    func setupTapToDismiss() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Dismisses the keyboard
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - User Interface Styling
    
    /// Makes a circular frame for avatarImageView
    func roundAvatarImageView() {
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
    }

    /// Image selected from image picker
    func imagePickerFinished(_ notification: Foundation.Notification) {
        let image = UIImage(named: "dude2.jpg")
        avatarImage.image = image
    }
    
    /// Setup the gender picker
    func setupGenderPicker() {
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderField.inputView = genderPicker
    }
    
    
    // MARK: - IBActions
    
    @IBAction func imageTapped(_ sender: AnyObject) {
        let image = UIImage(named: "dude2.jpg")
        avatarImage.image = image
    }
    

    // FIXME: - When user changes name, need to update database with new users name to connect old data
    @IBAction func savePressed(_ sender: AnyObject) {
        switch true {
        //case TextFieldValidator.emptyFieldExists(usernameField, emailField):
            //ErrorAlertService.displayAlertFor(.SettingsEmptyField, withPresenter: self)
        //case EmailValidator.invalidEmail(emailField.text!):
            //ErrorAlertService.displayAlertFor(.InvalidEmail, withPresenter: self)
        //case UsernameValidator.invalidCharactersIn(username: usernameField.text!):
            //ErrorAlertService.displayAlertFor(.InvalidUsername, withPresenter: self)
        //case UsernameValidator.usernameInvalidLength(usernameField.text!):
            //ErrorAlertService.displayAlertFor(.UsernameLength, withPresenter: self)
        //case WebsiteValidator.invalidWebsite(websiteField.text!):
            //ErrorAlertService.displayAlertFor(.InvalidWebsite, withPresenter: self)
        default:
            updateUserInformation()
        }
    }
    
}

// MARK: - Extenion UIPickerViewDelegate & UIPickerViewDataSource

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genders[row]
        dismissKeyboard()
    }
}
