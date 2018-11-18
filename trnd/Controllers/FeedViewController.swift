//
//  PostViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import CRRefresh
import KRProgressHUD

enum FeedMode {
    case singlePost(String)
    case allPosts
}

class FeedViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: AnyObject) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SearchViewControllerNAV")
        present(controller!, animated: true, completion: nil)
        
    }
    
    // MARK: - Properties
    var feedMode: FeedMode = .allPosts
    var feedDataSource: FeedDataSource?
    //var hidingNavBarManager: HidingNavigationBarManager?
    var rows = [String]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.offWhite()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            
            
        })
        self.setupBadPage()
        /// animator: your customize animator, default is NormalHeaderAnimator
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// start refresh
            /// Do anything you want...
            self?.download()
            self?.refreshData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                /// Stop refresh when your job finished, it will reset refresh footer if completion is true
                self?.tableView.cr.endHeaderRefresh()
                
            })
        }
        /// manual refresh
        //tableView.cr.beginHeaderRefresh()
        download()
        refreshData()
        backButton.isHidden = true
        addPostUploadObserver()
        setupFeedDataSource()
        setupSwipeToGoBack()
        setupAutoResizingRows()
        setupBackButton()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: false)
        download()
        refreshData()
        //hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        download()
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePostUploadObserver()
        //hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    /// Sets up the FeedDataSource
    func setupFeedDataSource() {
        feedDataSource = FeedDataSource(tableView: tableView)
        tableView.dataSource = feedDataSource
        
    }
    
    /// Downloads either a single post or all the posts based on the controllers FeedMode
    func download() {
        switch feedMode {
        case .singlePost(let id):
            feedDataSource?.downloadPost(id)
            //self.navigationItem.title = "Photo"
        case .allPosts:
            feedDataSource?.downloadAllPosts()
            //self.navigationItem.title = "photograph :)"
        }
    }
    
    /// Adds the controller as the observer for PostUpload
    func addPostUploadObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.refreshData), name: NSNotification.Name(rawValue: Notification.PostUploaded), object: nil)
    }
    
    /// Removes the controller as the observer for PostUpload
    func removePostUploadObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Notification.PostUploaded), object: nil)
    }
    
    // MARK: - User Interface
    
    /// Allows cells to automatically resize based on content size
    func setupAutoResizingRows() {
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 445
    }
    
    func setupBackButton() {
        switch feedMode {
        case.singlePost:
            backButton.isHidden = false
            //let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(FeedViewController.backPressed))
            //self.navigationItem.leftBarButtonItem = backButton
        case .allPosts:
            backButton.isHidden = true
            self.navigationItem.hidesBackButton = true
        }
    }
    
    /// Pops view controller off the navigation stack
    func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    /// Refreshes the controllers data
    @objc func refreshData() {
        tableView.reloadData()
    }

    // MARK: - Gesture Recognizers
    
    // FIXME: - Gesture not recognized on table view... only backing view
    
    /// Sets up a swipe gesture recognizer to go back to the previous view
    func setupSwipeToGoBack() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(FeedViewController.swipeToGoBack))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func setupBadPage() {
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.separatorStyle = .none
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.reachability.isReachable == false {
                let noConLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)! ]
                let myString = NSMutableAttributedString(string: "No Internet Connection.", attributes: myAttribute )
                noConLabel.numberOfLines = 0
                noConLabel.attributedText = myString
                noConLabel.textAlignment = NSTextAlignment.center
                noConLabel.textColor = UIColor.lightGray
                noConLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.tableView.backgroundView = noConLabel
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            } else {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 17)! ]
                let myString = NSMutableAttributedString(string: "Follow others to see their posts. \nStart by tapping the TRND button \nabove.", attributes: myAttribute )
                emptyLabel.numberOfLines = 0
                emptyLabel.attributedText = myString
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.tableView.backgroundView = emptyLabel
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            }
        }
        
        
    }
    
    /// Dismiesses view controller on swipe right gesture
    @objc func swipeToGoBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions

    @IBAction func usernameButtonPressed(_ sender: UIButton) {
        guard let username = sender.titleLabel?.text else { return }
        if  PFUser.current()?.username == username {
            print("this is ur profile dumbo")
        } else {
            NavigationManager.showProfileViewController(withPresenter: self, forUsername: username)
        }
        
    }

    @IBAction func commentButtonPressed(_ sender: AnyObject) {
        guard let indexPath = sender.layer.value(forKey: "index") as? IndexPath else { return }
        guard let feedDataSource = feedDataSource else { return }
        
        let uniqueID = feedDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
        let commentOwner = feedDataSource.usernames[(indexPath as NSIndexPath).row]
        NavigationManager.showCommentViewController(withPresenter: self, postID: uniqueID, commentOwner: commentOwner)
    }
    
    
    @IBAction func commentAction(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        guard let feedDataSource = feedDataSource else { return }
        
        let uniqueID = feedDataSource.uniqueIDs[(indexPath! as NSIndexPath).row]
        let commentOwner = feedDataSource.usernames[(indexPath! as NSIndexPath).row]
        NavigationManager.showCommentViewController(withPresenter: self, postID: uniqueID, commentOwner: commentOwner)
    }
    
    @IBAction func more2(_ sender: UIButton) {

    }
    
    @objc func likeAction(sender:UITapGestureRecognizer) {
        
    }
    func commentAction(sender: UIGestureRecognizer) {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            guard let feedDataSource = feedDataSource else { return }
            
            let uniqueID = feedDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
            let commentOwner = feedDataSource.usernames[(indexPath as NSIndexPath).row]
            NavigationManager.showCommentViewController(withPresenter: self, postID: uniqueID, commentOwner: commentOwner)
        }
    }
    
    @objc func moreAction(sender:UITapGestureRecognizer) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
        let indexPath: IndexPath? = tableView.indexPathForRow(at: buttonPosition)
        guard let cell = tableView.cellForRow(at: indexPath!) as? PostCell else { return }
        guard let feedDataSource = feedDataSource else { return }
        
        let postDescription = feedDataSource.postDescriptions[(indexPath! as NSIndexPath).row]
        let username = feedDataSource.usernames[(indexPath! as NSIndexPath).row]
        let uniqueID = feedDataSource.uniqueIDs[(indexPath! as NSIndexPath).row]
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
            // Delete locally
            feedDataSource.postDescriptions.remove(at: (indexPath! as NSIndexPath).row)
            feedDataSource.avatars.remove(at: (indexPath! as NSIndexPath).row)
            feedDataSource.usernames.remove(at: (indexPath! as NSIndexPath).row)
            feedDataSource.uniqueIDs.remove(at: (indexPath! as NSIndexPath).row)
            feedDataSource.dates.remove(at: (indexPath! as NSIndexPath).row)
            feedDataSource.postFiles.remove(at: (indexPath! as NSIndexPath).row)
            
            // Delete from server
            PostService.deletePostWith(uniqueID: uniqueID)
            CommentService.deleteComment(withPostID: uniqueID)
            HashtagService.deleteHashtag(withID: uniqueID)
            NotificationService.deleteNotification(withID: uniqueID)
            self.tableView.reloadData()
        }
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { (action: UIAlertAction) in
            guard let uniqueID = cell.postUniqueID else { return }
            guard let username = cell.usernameButton.titleLabel?.text else { return }
            ComplaintService.createComplaintFor(postDescription, withPostID: uniqueID, reportedUser: username) {
                ErrorAlertService.displayAlertFor(.ComplaintSent, withPresenter: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(cancelAction)
        PFUser.current()?.username == username ? actionSheet.addAction(deleteAction) : actionSheet.addAction(reportAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 620
    }
    
    private func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.rows.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No posts cuz no freyndz"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            return self.rows.count
        }
    }
    
    /*
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     guard let uniqueID = profileDataSource?.uniqueIDs[(indexPath as NSIndexPath).row] else { return }
     NavigationManager.showFeedViewController(withPresenter: self, forMode: FeedMode.singlePost(uniqueID))
     }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feedDataSource = feedDataSource else { return }
        
        _ = feedDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
        _ = feedDataSource.usernames[(indexPath as NSIndexPath).row]
        //NavigationManager.showCommentViewController(withPresenter: self, postID: uniqueID, commentOwner: commentOwner)
    }
    
}
