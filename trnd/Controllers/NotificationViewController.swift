//
//  NotificationViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class NotificationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: - Properties
    var notificationDataSource: NotificationDataSource?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationDataSource()
        setupUserInterface()
        hideNotificationIndicator()
        
        self.navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navBar.shadowImage = UIImage()
        
        let popFlatButtonLeft = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), buttonType: FlatButtonType.buttonDownBasicType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        popFlatButtonLeft?.tintColor = UIColor.black
        //popFlatButtonLeft?.addTarget(self, action: #selector(ProfileViewController.backPressed), for: UIControl.Event.touchUpInside)
        let collapseButtonLeft = UIBarButtonItem(customView: popFlatButtonLeft!)
        self.navBar.topItem?.leftBarButtonItem = collapseButtonLeft
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationDataSource?.downloadNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //resetUserInterface()
    }
    
    // MARK: - Methods
    
    func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNotificationDataSource() {
        notificationDataSource = NotificationDataSource(tableView: tableView)
        tableView.dataSource = notificationDataSource
    }
    
    func setupUserInterface() {
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        self.navigationItem.title = "Notifications"
    }
    
    func hideNotificationIndicator() {
       /* guard let tabBar = self.tabBarController as? TabBarController else { return }
        UIView.animateWithDuration(1.0, delay: 8, options: [], animations: { 
            tabBar.corner.hidden = true
            tabBar.iconContainer.hidden = true
            tabBar.dot.hidden = true
        }, completion: nil)*/
    }
    
    func resetUserInterface() {
        guard let notificationDataSource = notificationDataSource else { return }
        //notificationDataSource.usernames.removeAll()
        //notificationDataSource.avatarFiles.removeAll()
        //notificationDataSource.notificat@objc ionTypes.removeAll()
        //notificationDataSource.dates.removeAll()
        //notificationDataSource.uniqueIDs.removeAll()
        //notificationDataSource.owners.removeAll()
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let notificationDataSource = notificationDataSource else { return }
        let notification = notificationDataSource.notificationTypes[(indexPath as NSIndexPath).row]
        let username = notificationDataSource.usernames[(indexPath as NSIndexPath).row]
        let uniqueID = notificationDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
        let owner = notificationDataSource.owners[(indexPath as NSIndexPath).row]
        
        switch notification {
        case NotificationType.Comment.rawValue:
            NavigationManager.showCommentViewController(withPresenter: self, postID: uniqueID, commentOwner: owner)
        case NotificationType.Mention.rawValue:
            NavigationManager.showFeedViewController(withPresenter: self, forMode: .singlePost(uniqueID))
        case NotificationType.Like.rawValue:
            NavigationManager.showFeedViewController(withPresenter: self, forMode: .singlePost(uniqueID))
        case NotificationType.Follow.rawValue:
            NavigationManager.showProfileViewController(withPresenter: self, forUsername: username)
        default: break
        }
    }
}
