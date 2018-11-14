//
//  PostCommentCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit

class PostCommentCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Methods
    func configureWith(_ username: String, comment: String, date: Date?) {
        self.usernameButton.setTitle(username, for: UIControl.State())
        self.usernameButton.sizeToFit()
        self.commentLabel.text = comment
    }
    
}
