//
//  PostInfoCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import KILabel
import FLAnimatedImage
//import DOFavoriteButton

class PostInfoCell: UITableViewCell {
    
    // MARK: - Properties
    var postUniqueID: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postMessageLabel: KILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    // MARK: - Methods
    
    
    // MARK: - Configuration
    
    /// Configures a post using a username, time, title, and the unique ID for the post
    func configurePost(_ username: String, date: Date, title: String, location: String, latitude: String, longitude: String, uniqueID: String, indexPath: IndexPath) {
        
        usernameButton.setTitle(username, for: UIControl.State())
        postMessageLabel.text = title
        postMessageLabel.sizeToFit()
        
        var _ : Float = NSString(string: latitude).floatValue
        var _ : Float = NSString(string: latitude).floatValue
        
        
        
        locationButton.titleLabel?.text = location
        
        avatarImage.layer.cornerRadius = 4
        avatarImage.clipsToBounds = true
        
        configureDataLabel(date)
        //setupLikeTap()
        //likeButton.addTarget(self, action: Selector("tapped:"), for: .touchUpInside)
        /// Used for navigation
        commentButton.layer.setValue(indexPath, forKey: "index")
        moreButton.layer.setValue(indexPath, forKey: "index")
        self.postUniqueID = uniqueID
    }
    
    
    /// Configures the date label of the post
    func configureDataLabel(_ date: Date) {
        let today = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        _ = (Calendar.current as NSCalendar).components(components, from: date, to: today, options: [])
        
        /*switch difference {
         case _ where difference.weekOfMonth! > 0: self.timeStamp.text = "\(difference.weekOfMonth!)w."
         case _ where difference.day! > 0 && difference.weekOfMonth! == 0: self.timeStamp.text = "\(difference.day!)d."
         case _ where difference.hour! > 0 && difference.day! == 0: self.timeStamp.text = "\(difference.hour!)h."
         case _ where difference.minute! > 0 && difference.hour! == 0: self.timeStamp.text = "\(difference.minute!)m."
         case _ where difference.second! > 0 && difference.minute! == 0: self.timeStamp.text = "\(difference.second!)s."
         case _ where difference.second! <= 0: self.timeStamp.text = "now"
         default: break
         }*/
    }
    

    /// Configures the like count for the like label
    func configureLikeLabel() {
        guard let id = self.postUniqueID else { return }
        LikeService.likeCountForPost(withUniqueID: id) { (count: Int) in
            self.likeCountLabel.text = "\(count)"
        }
    }
    
    // MARK: - Gesture Recognizers
    
    // MARK: - Interactions
    
    /// Determines whether to like or unlike the post and configures the like buttons appearance
    func likeOrUnlikePost() {
        guard let id = self.postUniqueID else { return }
        LikeService.userHasLikedPost(withUniqueID: id) { (hasLiked: Bool) in
            if hasLiked {
                LikeService.unlikePost(withUniqueID: id) {
                    //self.configureLikeButton(false)
                    self.configureLikeLabel()
                }
            } else {
                guard let owner = self.usernameButton.titleLabel?.text else { return }
                LikeService.likePost(withUniqueID: id, postOwner: owner) {
                    //self.configureLikeButton(true)
                    self.configureLikeLabel()
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func likeButtonPressed(_ sender: AnyObject) {
        likeOrUnlikePost()
    }
}
