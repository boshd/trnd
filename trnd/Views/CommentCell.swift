//
//  CommentCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import KILabel

class CommentCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var commentLabel: KILabel!
    
    // MARK: - Methods
    func configureWith(_ username: String, comment: String, date: Date?) {
        self.usernameButton.setTitle(username, for: UIControl.State())
        self.usernameButton.sizeToFit()
        self.commentLabel.text = comment
        if let date = date {
            configureDataLabel(date)
        }
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.width / 2
        self.avatarImage.clipsToBounds = true
    }
    
    /// Configures the date label of the post
    func configureDataLabel(_ date: Date) {
        let today = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: date, to: today, options: [])
        
        switch difference {
        case _ where difference.weekOfMonth! > 0: self.timeStamp.text = "\(String(describing: difference.weekOfMonth))w."
        case _ where difference.day! > 0 && difference.weekOfMonth! == 0: self.timeStamp.text = "\(String(describing: difference.day))d."
        case _ where difference.hour! > 0 && difference.day! == 0: self.timeStamp.text = "\(String(describing: difference.hour))h."
        case _ where difference.minute! > 0 && difference.hour! == 0: self.timeStamp.text = "\(String(describing: difference.minute))m."
        case _ where difference.second! > 0 && difference.minute! == 0: self.timeStamp.text = "\(String(describing: difference.second))s."
        case _ where difference.second! <= 0: self.timeStamp.text = "now"
        default: break
        }
    }

}
