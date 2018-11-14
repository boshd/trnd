//
//  NotificationDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class NotificationDataSource: NSObject {
    // MARK: - Properties
    var tableView: UITableView
    
    var usernames = [String]()
    var avatarFiles = [PFFile]()
    var notificationTypes = [String]()
    var dates = [Date]()
    var uniqueIDs = [String]()
    var owners = [String]()
    var notificationsToDownload = 10
    
    // MARK: - Initializers
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Methods
    
    func downloadNotifications() {
        
        NotificationService.retrieveNotifications(withLimit: notificationsToDownload)
        { (usernames: [String], files: [PFFile], notifTypes: [String], dates: [Date], uniqueIDs: [String], owners: [String]) in
            
            /*self.usernames.removeAll()
            self.avatarFiles.removeAll()
            self.notificationTypes.removeAll()
            self.dates.removeAll()
            self.uniqueIDs.removeAll()
            self.owners.removeAll()*/
            
            self.usernames.append(contentsOf: usernames)
            self.avatarFiles.append(contentsOf: files)
            self.notificationTypes.append(contentsOf: notifTypes)
            self.dates.append(contentsOf: dates)
            self.uniqueIDs.append(contentsOf: uniqueIDs)
            self.owners.append(contentsOf: owners)
            
            self.tableView.reloadData()
        }
    }
}

extension NotificationDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.NotificationCell, for: indexPath) as? NotificationCell ?? NotificationCell()
        let username = usernames[(indexPath as NSIndexPath).row]
        let date = dates[(indexPath as NSIndexPath).row]
        let type = notificationTypes[(indexPath as NSIndexPath).row]
        
        cell.configureWith(username, notificationType: type, date: date)
        
        let file = avatarFiles[(indexPath as NSIndexPath).row]
        ParseOperation.getData(forFile: file) { (data: NSData) in
            guard let image = UIImage(data: data as Data) else { return }
            DispatchQueue.main.async {
                cell.avatarImage.image = image
            }
        }
        
        
        return cell
    }
}
