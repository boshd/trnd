//
//  SearchDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class SearchTableDataSource: NSObject {
    
    // MARK: - Properties
    var tableView: UITableView
    
    var usernames = [String]()
    var avatarFiles = [PFFile]()
    var usersToLoad = 10
    
    // MARK: - Initializer
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Methods
    
    func searchUsers(_ text: String) {
        
        SearchService.getUsersWhere(queryKey: QueryKey.Username, contains: text, withLimit: usersToLoad) { (usernames: [String], files: [PFFile]) in
            
            if usernames.count == 0 {
                SearchService.getUsersWhere(queryKey: QueryKey.FullName, contains: text, withLimit: self.usersToLoad) { (usernames: [String], files: [PFFile]) in
                    self.usernames.removeAll()
                    self.avatarFiles.removeAll()
                    self.usernames.append(contentsOf: usernames)
                    self.avatarFiles.append(contentsOf: files)
                    self.tableView.reloadData()
                }
                
            } else {
                self.usernames.removeAll()
                self.avatarFiles.removeAll()
                self.usernames.append(contentsOf: usernames)
                self.avatarFiles.append(contentsOf: files)
                self.tableView.reloadData()
            }
        }
        
    }
}

extension SearchTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.FollowCell, for: indexPath) as? FollowCell ?? FollowCell()
        
        guard let currentUsername = PFUser.current()?.username else { return cell }
        let username = usernames[(indexPath as NSIndexPath).row]
        let file = avatarFiles[(indexPath as NSIndexPath).row]
        
        //cell.usernameLabel.text = username
        cell.usernameButton.setTitle(username, for: .normal)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            ParseOperation.getData(forFile: file) { (data: NSData) in
                guard let image = UIImage(data: data as Data) else { return }
                cell.configureImage(image)
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
