//
//  NotificationCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var timeStamp: UILabel!


    func configureWith(_ username: String, notificationType: String, date: Date) {
        self.usernameButton.setTitle(username, for: UIControl.State())
        configureNotificationMessage(notificationType)
        configureTimeStamp(date)
        self.avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        self.avatarImage.clipsToBounds = true
    }
    
    func configureNotificationMessage(_ type: String) {
        switch type {
        case NotificationType.Mention.rawValue:
            notification.text = "mentioned you."
        case NotificationType.Comment.rawValue:
            notification.text = "commented on your post."
        case NotificationType.Like.rawValue:
            notification.text = "liked your post!"
        case NotificationType.Follow.rawValue:
            notification.text = "is now following you."
        default: break
        }
    }
    
    func configureTimeStamp(_ date: Date) {
        let today = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: date, to: today, options: [])
        
        switch difference {
        case _ where difference.weekOfMonth! > 0: self.timeStamp.text = "\(difference.weekOfMonth)w."
        case _ where difference.day! > 0 && difference.weekOfMonth! == 0: self.timeStamp.text = "\(String(describing: difference.day))d."
        case _ where difference.hour! > 0 && difference.day! == 0: self.timeStamp.text = "\(String(describing: difference.hour))h."
        case _ where difference.minute! > 0 && difference.hour! == 0: self.timeStamp.text = "\(String(describing: difference.minute))m."
        case _ where difference.second! > 0 && difference.minute! == 0: self.timeStamp.text = "\(String(describing: difference.second))s."
        case _ where difference.second! <= 0: self.timeStamp.text = "now"
        default: break
        }
    }
}
