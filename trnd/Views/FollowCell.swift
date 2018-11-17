//
//  FollowCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class FollowCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var followImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //elf.followImage.frame = CGRectMake(8, 8, 60, 60)
        self.followImage.layer.cornerRadius = 4
        self.followImage.clipsToBounds = true
        
        followButton.layer.cornerRadius = 6
        //followButton.layer.borderWidth = 1
        //followButton.layer.borderColor = UIColor.fabGold().CGColor
    }
    
    func configureImage(_ image: UIImage) {
        self.followImage.image = image
    }
    
    func configure(_ image: UIImage?, username: String, following: Bool?) {
        followImage.image = image
        usernameLabel.text = username
        followButton.isHidden = username == PFUser.current()?.username
        guard let following = following else { return }
        configureButton(following)
    }
    
    func configureButton(_ following: Bool) {
        
        let title = following ? "following" : "follow"
        followButton.setTitle(title, for: UIControl.State())
        //followButton.backgroundColor = following ? UIColor.followingGreen() : UIColor.followBlue()
    }
    
    // MARK: - IBActions
    
    @IBAction func followButtonPressed(_ sender: AnyObject) {
        guard let username = usernameButton.titleLabel?.text else { return }

        if followButton.titleLabel?.text == "following" {
            FollowService.unfollow(username)
            configureButton(false)
        } else if followButton.titleLabel?.text == "follow" {
            FollowService.follow(username)
            configureButton(true)
        }
    }
}
