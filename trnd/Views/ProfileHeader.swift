//
//  ProfileReusableView.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse


class ProfileHeader: UICollectionReusableView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImage: UIImageView!
    //@IBOutlet weak var totalPostsLabel: UILabel!
    @IBOutlet weak var totalFollowersLabel: UILabel!
    @IBOutlet weak var totalFollowingLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    //@IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    //@IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileBox: UIView!

    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    // Configures the header for the profile owner
    func configure(forUser user: PFUser) {
        //self.fullNameLabel.text = user.object(forKey: "fullName") as? String
        let usernameString = "@\((user.object(forKey: "username") as? String)!)"
        self.usernameLabel.text = usernameString
        self.profileButton.layer.cornerRadius = 5
        self.profileButton.clipsToBounds = true
        //self.bioLabel.text = user.objectForKey("bio") as? String
        //self.websiteTextView.text = user.objectForKey("website") as? String
        
        self.profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        //self.profileButton.layer.cornerRadius = 34/2
        
        self.profileImage.clipsToBounds = true
        //self.profileImage.layer.cornerRadius = 81/2
        //self.shadowView.layer.cornerRadius = 150/2
        //self.gradientView.layer.cornerRadius = 50
        //self.profileButton.clipsToBounds = true
    }

    // Configure profile button
    func configureButton(_ user: PFUser, isFollowing: Bool) {
        var title = isFollowing ? "following" : "follow"
        //var buttonColor = isFollowing ? UIColor.fabGold() : UIColor.fabGold()
        var textColor = UIColor.white
        
        if PFUser.current()?.username == user.username {
            title = "edit your profile"
            //buttonColor = UIColor.editProfileGray()
            textColor = UIColor.white
        }
        profileButton.setTitle(title, for: UIControl.State())
        //rofileButton.backgroundColor = buttonColor
        profileButton.setTitleColor(textColor, for: UIControl.State())
        //profileButton.layer.cornerRadius = 5
        profileButton.clipsToBounds = true
    }
    
}

