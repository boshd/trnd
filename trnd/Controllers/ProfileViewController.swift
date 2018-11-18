//
//  ProfileViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import VBFPopFlatButton
import QuartzCore
import CRRefresh
import FLAnimatedImage
import SwiftIconFont

// Controls the data being shown in the ProfileViewController
enum ProfileMode {
    case currentUser
    case guest(String)
}

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Props
    var profileUsername: String?
    var profileMode: ProfileMode = .currentUser
    var profileDataSource: ProfileDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.downloadProfileData()
            self?.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.collectionView.cr.endHeaderRefresh()
            })
        }
        
        let popFlatButtonRight = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), buttonType: FlatButtonType.buttonForwardType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        popFlatButtonRight?.tintColor = UIColor.black
        popFlatButtonRight?.addTarget(self, action: #selector(ProfileViewController.goToSettings), for: UIControl.Event.touchUpInside)
        let collapseButtonRight = UIBarButtonItem(customView: popFlatButtonRight!)
        
        self.closeLabel.isHidden = true
        
        collectionView.delegate = self
        self.collectionView.reloadData()
        collectionView.alwaysBounceVertical = true
        
        downloadProfileData()
        setupNavigationBar()
        setupProfileDataSource()
        
        let closeGR = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeView))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(closeGR)
        closeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
        closeLabel.textColor = UIColor.offWhite()
        closeLabel.text = String.fontAwesomeIcon("angledown")
        
        
    }
    
    func refreshData() {
        self.collectionView.reloadData()
    }
    
    @objc func goToSettings() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AccountSettingsViewController")
        present(controller!, animated: false, completion: nil)
    }
 
    func setupEmptyView() {
        if collectionView.numberOfItems(inSection: 0) == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20.0)! ]
            let myString = NSMutableAttributedString(string: "\n\n\n\n\n\n\n\nNo posts yet.", attributes: myAttribute )
            emptyLabel.numberOfLines = 0
            emptyLabel.attributedText = myString
            emptyLabel.textAlignment = NSTextAlignment.center
            emptyLabel.textColor = UIColor.lightGray
            emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.collectionView.backgroundView = emptyLabel
        }
    }
    
    @objc func closeView(sender: UIGestureRecognizer) {
        dismiss(animated: true) {
            self.refreshData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch profileMode {
        case .currentUser:
             self.closeLabel.isHidden = true
        case .guest:
            self.closeLabel.isHidden = false
        }
        
        self.collectionView.reloadData()
        downloadProfileData()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    /// Sets up the ProfileDataSource
    func setupProfileDataSource() {
        profileDataSource = ProfileDataSource(collectionView: collectionView)
        collectionView.dataSource = profileDataSource
    }
    
    /// Downloads profile data
    func downloadProfileData() {
        switch profileMode {
        case .currentUser:
            profileDataSource?.downloadDataForCurrentUser()
        case .guest(let username):
            profileUsername = username
            profileDataSource?.downloadDataForGuest(username) {
                ErrorAlertService.displayAlertFor(.DoesNotExist, withPresenter: self)
            }
        }
    }
    
    /// Set navigation bar title
    func setupNavigationBar() {
        switch profileMode {
        case .currentUser:
            self.closeLabel.isHidden = true
        case .guest:
            self.closeLabel.isHidden = false
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func totalFollowersPressed(_ sender: AnyObject) {
        guard let dataSource = profileDataSource else { return }
        guard let followMode: FollowMode = .followers(dataSource.profileOwner) else { return }
        NavigationManager.showFollowViewController(withPresenter: self, forMode: followMode)
    }
  
    
    @IBAction func totalFollowingPressed(_ sender: AnyObject) {
        guard let dataSource = profileDataSource else { return }
        guard let followMode: FollowMode = .following(dataSource.profileOwner) else { return }
        NavigationManager.showFollowViewController(withPresenter: self, forMode: followMode)
    }
    
    @IBAction func totalPostsPressed(_ sender: AnyObject) {
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "PostsViewController")
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController!.pushViewController(VC, animated: false)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        switch title {
        case "edit your profile":
            NavigationManager.showSettingsViewController(withPresenter: self)
        case "following":
            sender.setTitle("follow", for: UIControl.State())
            if let profileUsername = profileUsername {
                FollowService.unfollow(profileUsername) {
                    self.collectionView.reloadData()
                }
            }
        case "follow":
            sender.setTitle("following", for: UIControl.State())
            if let profileUsername = profileUsername {
                FollowService.follow(profileUsername) {
                    self.collectionView.reloadData()
                }
            }
        default: break
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let file = files[(indexPath as NSIndexPath).row]
        return CGSize(width: 124, height: 124)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uniqueID = profileDataSource?.uniqueIDs[(indexPath as NSIndexPath).row] else { return }
        NavigationManager.showFeedViewController(withPresenter: self, forMode: FeedMode.singlePost(uniqueID))
    }

}
