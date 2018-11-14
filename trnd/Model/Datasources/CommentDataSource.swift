//
//  CommentDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class CommentDataSource: NSObject {
    
    // MARK: - Properties
    var tableView: UITableView
    var commentsToLoad = 15
    
    var usernames = [String]()
    var avatars = [PFFile]()
    var comments = [String]()
    var dates = [Date?]()
    
    
    // MARK: - Initializers
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    // MARK: - Methods
    
    func downloadComments(_ postID: String) {
        CommentService.countComments(withPostID: postID) { (count: Int) in
            let skip = count - self.commentsToLoad
            CommentService.retrieveComments(forPostID: postID, andSkip: skip)
            { (usernames: [String], avatars: [PFFile], comments: [String], dates: [Date?]) in
                // Clean up
                self.usernames.removeAll()
                self.avatars.removeAll()
                self.comments.removeAll()
                self.dates.removeAll()
                // Add data
                self.usernames.append(contentsOf: usernames)
                self.avatars.append(contentsOf: avatars)
                self.comments.append(contentsOf: comments)
                self.dates.append(contentsOf: dates)
                self.tableView.reloadData()
                self.scrollToRow(comments.count - 1)
            }
        }
    }
    
    /// Not being used yet
    func scrollToRow(_ row: Int?) {
        if let row = row , row > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: row - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    /// Not being used yet
    func loadMoreComments(_ postID: String) {
        CommentService.countComments(withPostID: postID) { (count: Int) in
            if self.commentsToLoad < count {
                self.commentsToLoad += 15
            }
            self.downloadComments(postID)
        }
    }
    
    /// Sets up the mention handler to navigate to a mentioned users page
    func setupMentionTapHandler(_ cell: CommentCell) {
        cell.commentLabel.userHandleLinkTapHandler = { label, handle, range in
            var mention = handle
            mention = String(mention.dropFirst())
            if let controller = self.tableView.delegate as? CommentViewController {
                NavigationManager.showProfileViewController(withPresenter: controller, forUsername: mention.lowercased())
            }
        }
    }
    
    /// Sets up the hashtag handler to navigate to the hashtag view controller
    func setupHashtagMentionHandler(_ cell: CommentCell) {
        cell.commentLabel.hashtagLinkTapHandler = { label, handle, range in
            var hashtag = handle
            hashtag = String(hashtag.dropFirst())
            if let controller = self.tableView.delegate as? CommentViewController {
                NavigationManager.showHashtagViewController(withPresenter: controller, hashtag: hashtag.lowercased())
            }
        }
    }
}

extension CommentDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.CommentCell, for: indexPath) as? CommentCell ?? CommentCell()
        setupMentionTapHandler(cell)
        setupHashtagMentionHandler(cell)
        
        let username = usernames[(indexPath as NSIndexPath).row]
        let comment = comments[(indexPath as NSIndexPath).row]
        let avatarFile = avatars[(indexPath as NSIndexPath).row]
        let date = dates[(indexPath as NSIndexPath).row]
        
        cell.configureWith(username, comment: comment, date: date)
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: avatarFile) { (data: NSData) in
                guard let image = UIImage(data: data as Data) else { return }
                DispatchQueue.main.async {
                    cell.avatarImage.image = image
                }
            }
        }
        return cell
    }
}
