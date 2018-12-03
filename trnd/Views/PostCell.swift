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
    @IBOutlet weak var commentAvatar: UIImageView!
    //@IBOutlet weak var postImage: UIImageView!
    //@IBOutlet weak var animatedPostView: FLAnimatedImageView!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var postMessageLabel: KILabel!
    //@IBOutlet weak var postVideoView: VideoView!

    // MARK: - Methods
    
    func setupButtons() {
        let like_title = "fa:hearto"
        likeButton.setAttributedTitle(nil, for: .normal)
        likeButton.titleLabel?.text = like_title
        likeButton.setTitle("\(like_title)", for: .normal)
        likeButton.setTitleColor(UIColor.offBlack(), for: .normal)
        likeButton.parseIcon()
        
        let more_title = "fa:ellipsish"
        moreButton.setAttributedTitle(nil, for: .normal)
        moreButton.titleLabel?.text = more_title
        moreButton.setTitle("\(more_title)", for: .normal)
        moreButton.setTitleColor(UIColor.offBlack(), for: .normal)
        moreButton.parseIcon()
    }
    
    @objc func likeAction(sender:UITapGestureRecognizer) {

    }
    
    @objc func commentAction(sender:UITapGestureRecognizer) {

    }

    @objc func moreAction(sender:UITapGestureRecognizer) {

    }
    
    // MARK: - Configuration
    
    // Configures a post using a username, time, title, and the unique ID for the post
    func configurePost(_ username: String, date: Date?, title: String, location: String, latitude: String, longitude: String, uniqueID: String, indexPath: IndexPath) {

        setupButtons()

        if let date = date {
            configureDataLabel(date)
        }
        animatedImageView.clipsToBounds = true
        self.backgroundColor = UIColor.offWhite()
        usernameButton.setTitle("\(username)", for: UIControl.State())
        postMessageLabel.text = title
        self.avatarImage.layer.cornerRadius = 20
        self.avatarImage.clipsToBounds = true
        self.commentAvatar.layer.cornerRadius = 15
        self.commentAvatar.clipsToBounds = true

    }
    @IBAction func likeAction(_ sender: Any) {
        
        if likeButton.currentTitleColor == UIColor.offBlack() {
            let like_title = "fa:heart"
            likeButton.setAttributedTitle(nil, for: .normal)
            likeButton.titleLabel?.text = like_title
            likeButton.setTitle("\(like_title)", for: .normal)
            likeButton.setTitleColor(UIColor.litPink(), for: .normal)
            likeButton.parseIcon()
            likeCountLabel.text = "1"
        } else {
            let like_title = "fa:hearto"
            likeButton.setAttributedTitle(nil, for: .normal)
            likeButton.titleLabel?.text = like_title
            likeButton.setTitle("\(like_title)", for: .normal)
            likeButton.setTitleColor(UIColor.offBlack(), for: .normal)
            likeButton.parseIcon()
            likeCountLabel.text = "0"
        }
    }
    
    /// Configures the date label of the post
    func configureDataLabel(_ date: Date) {
        let today = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: date, to: today, options: [])
        
        switch difference {
        case _ where difference.weekOfMonth! > 0: self.timeStamp.text = "\(difference.weekOfMonth ?? 0) WEEK(S) AGO"
        case _ where difference.day! > 0 && difference.weekOfMonth! == 0: self.timeStamp.text = "\(difference.day ?? 0) DAY(S) AGO"
        case _ where difference.hour! > 0 && difference.day! == 0: self.timeStamp.text = "\(difference.hour ?? 0) HOUR(S) AGO"
        case _ where difference.minute! > 0 && difference.hour! == 0: self.timeStamp.text = "\(difference.minute ?? 0) MINUTE(S) AGO"
        case _ where difference.second! > 0 && difference.minute! == 0: self.timeStamp.text = "\(difference.second ?? 0) SECOND(S) AGO"
        case _ where difference.second! <= 0: self.timeStamp.text = "JUST NOW"
        default: break
        }
    }

}
    

