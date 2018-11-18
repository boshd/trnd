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
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postMessageLabel: KILabel!
    //@IBOutlet weak var postVideoView: VideoView!

    // MARK: - Methods
    
    func setupGestures() {
        let likeGR = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeAction))
        likeLabel.isUserInteractionEnabled = true
        likeLabel.addGestureRecognizer(likeGR)
        
        //let commGR = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.commentAction))
        let commGR = UITapGestureRecognizer(target: self, action:#selector(PostCell.commentAction))
        commentLabel.isUserInteractionEnabled = true
        commentLabel.addGestureRecognizer(commGR)
        
        let moreGR = UITapGestureRecognizer(target: self, action: #selector(PostCell.moreAction))
        moreLabel.isUserInteractionEnabled = true
        moreLabel.addGestureRecognizer(moreGR)
    }
    
    func setupButtons() {
        likeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 20)
        likeLabel.textColor = UIColor.offBlack()
        likeLabel.text = String.fontAwesomeIcon("hearto")
        commentLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 20)
        commentLabel.textColor = UIColor.offBlack()
        commentLabel.text = String.fontAwesomeIcon("comment")
        moreLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 20)
        moreLabel.textColor = UIColor.offBlack()
        moreLabel.text = String.fontAwesomeIcon("ellipsish")
    }
    
    @objc func likeAction(sender:UITapGestureRecognizer) {
        if likeLabel.textColor == UIColor.offBlack() {
            likeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 20)
            likeLabel.textColor = UIColor.litPink()
            likeLabel.text = String.fontAwesomeIcon("heart")
        } else {
            likeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 20)
            likeLabel.textColor = UIColor.offBlack()
            likeLabel.text = String.fontAwesomeIcon("hearto")
        }
    }
    
    @objc func commentAction(sender:UITapGestureRecognizer) {

    }

    @objc func moreAction(sender:UITapGestureRecognizer) {

    }
    
    // MARK: - Configuration
    
    // Configures a post using a username, time, title, and the unique ID for the post
    func configurePost(_ username: String, date: Date, title: String, location: String, latitude: String, longitude: String, uniqueID: String, indexPath: IndexPath) {

        setupButtons()
        setupGestures()

        self.backgroundColor = UIColor.offWhite()
        usernameButton.setTitle("\(username)", for: UIControl.State())
        postMessageLabel.text = title
        self.avatarImage.layer.cornerRadius = 20
        self.avatarImage.clipsToBounds = true

    }

}
    

