//
//  FollowViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

// Controls the data being shown in the FollowViewController
enum FollowMode {
    case followers(PFUser?)
    case following(PFUser?)
}

class FollowViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var followMode: FollowMode?
    var followDataSource: FollowDataSource?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFollowDataSource()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.downWeGo))
        swipeDown.delegate = self
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = .down
        self.tableView!.addGestureRecognizer(swipeDown)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func downWeGo() {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadFollowData()
        setupNavigationBar()
    }
    
    @IBAction func dismissAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Methods
    
    /// Sets up the FollowDataSource
    func setupFollowDataSource() {
        followDataSource = FollowDataSource(tableView: tableView)
        tableView.dataSource = followDataSource
        tableView.delegate = self
    }
    
    /// Download the follow data
    func downloadFollowData() {
        guard let followDataSource = followDataSource else { return }
        guard let followMode = followMode else { return }
        
        switch followMode {
        case .followers(let user):
            guard let user = user else { return }
            followDataSource.loadFollowers(forUser: user)
        case .following(let user):
            guard let user = user else { return }
            followDataSource.loadFollowings(forUser: user)
        }
    }
    
    /// Setup navigation bar title
    func setupNavigationBar() {
        guard let followMode = followMode else { return }
        
        switch followMode {
        case .following:
            self.navigationItem.title = "Following"
        case .followers:
            self.navigationItem.title = "Followers"
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.fabishPink()
        
    }
}

// MARK: - UITableViewDelegate

extension FollowViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let followDataSource = followDataSource else { return }
        let username = followDataSource.usernames[(indexPath as NSIndexPath).row]
        NavigationManager.showProfileViewController(withPresenter: self, forUsername: username)
    }
}
