//
//  FollowDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class FollowDataSource: NSObject {
    
    // MARK: - Properties
    var tableView: UITableView
    var dataForUser: PFUser?
    
    var usernames = [String]()
    
    
    // MARK: - Initializer
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    /// Loads the users that the user is following
    func loadFollowings(forUser user: PFUser) {
        self.dataForUser = user
        guard let name = user.username else { return }
        FollowService.getFollowingNamesFor(name) { (usernames: [String]) in
            self.usernames.removeAll()
            self.usernames = usernames
            self.tableView.reloadData()
        }
    }
    
    /// Loads the followers of the user
    func loadFollowers(forUser user: PFUser) {
        self.dataForUser = user
        guard let name = user.username else { return }
        FollowService.getFollowerNamesFor(name) { (usernames: [String]) in
            self.usernames.removeAll()
            self.usernames = usernames
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension FollowDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.FollowCell, for: indexPath) as? FollowCell ?? FollowCell()
        guard let currentUsername = PFUser.current()?.username else { return cell }
        let username = usernames[(indexPath as NSIndexPath).row]
        cell.usernameLabel.text = username
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            UserService.getUserWithName(username) { (user: PFUser?, success: Bool) in
                if success {
                    UserService.getAvatarImgForUser(user!) { (image: UIImage) in
                        cell.configureImage(image)
                    }
                }
            }
            
            FollowService.isUserFollowing(username) { (following: Bool) in
                DispatchQueue.main.async {
                    cell.followButton.isHidden = currentUsername == username
                    cell.configureButton(following)
                }
            }
        }
        return cell
    }
}
