//
//  PostCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import KILabel
import FLAnimatedImage
import AVFoundation
//import DOFavoriteButton

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    var postUniqueID: String?
    var likeCounts: Int = 0
    var player: AVPlayer?
    var videoUrl: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    //@IBOutlet weak var postImage: UIImageView!
    //@IBOutlet weak var animatedPostView: FLAnimatedImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postMessageLabel: KILabel!
    //@IBOutlet weak var postVideoView: VideoView!

    // MARK: - Methods

    
    // MARK: - Configuration
    
    // Configures a post using a username, time, title, and the unique ID for the post
    func configurePost(_ username: String, date: Date, title: String, location: String, latitude: String, longitude: String, uniqueID: String, indexPath: IndexPath) {

        
        // username
        usernameButton.setTitle("\(username)", for: UIControl.State())
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        // lat-lon
        var lat : Float = NSString(string: latitude).floatValue
        var lon : Float = NSString(string: latitude).floatValue
        
        // avatar
        self.avatarImage.layer.cornerRadius = 20
        self.avatarImage.clipsToBounds = true

    }

    @IBAction func likeAction(_ sender: Any) {
        if likeButton.currentImage == UIImage(named: "Unlike") {
            //likeButton.setImage(UIImage(named: "Like"), for: UIControlState.normal)
        } else {
            //likeButton.setImage(UIImage(named: "Unlike"), for: UIControlState.normal)
        }
    }
    func like() {

    }

}
    

