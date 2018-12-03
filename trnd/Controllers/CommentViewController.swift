//
//  CommentViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var inputContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var postUniqueID: String?
    var commentOwner: String?
    
    var keyboardHeight: CGFloat = 0
    var commentDataSource: CommentDataSource?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommentDataSource()
        setupUI()

        KeyboardObserver.startObservingWillShow(self, selector: #selector(CommentViewController.keyboardWillShow))
        KeyboardObserver.startObservingWillHide(self, selector: #selector(CommentViewController.keyboardWillHide))

        tableView.delegate = self
        commentTextView.delegate = self
        
        let closeGR = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeView))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(closeGR)
        closeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 35.0)
        closeLabel.textColor = UIColor.offWhite()
        closeLabel.text = String.fontAwesomeIcon("angledown")
        
    }
    
    @objc func closeView(sender: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hideTabBarFrame(true)
        commentTextView.becomeFirstResponder()
        commentDataSource?.scrollToRow(commentDataSource?.comments.count)
        loadComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //hideTabBarFrame(false)
        
    }
    
    deinit {
        KeyboardObserver.endObservingWillHide(self)
        KeyboardObserver.endObservingWillShow(self)
    }
    
    // MARK: - Methods
    
    @IBAction func backAction(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Downloads
    
    /// Loads the comments from the post into the data source
    func loadComments() {
        guard let postUniqueID = postUniqueID else { return }
        commentDataSource?.downloadComments(postUniqueID)
    }
    
    /// Sets up the CommentDataSource
    func setupCommentDataSource() {
        commentDataSource = CommentDataSource(tableView: tableView)
        tableView.dataSource = commentDataSource
    }
    
    // MARK: - User Interface
    
    /// Sets up the initial UI of the controller
    func setupUI() {
        commentTextView.layer.cornerRadius = commentTextView.frame.size.width / 50
        commentTextView.clipsToBounds = true
        commentTextView.autocorrectionType = .no
        self.navigationItem.title = "Comments"
        sendButton.isEnabled = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(CommentViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Hides or unhides the tab bar when entering or exiting the view
    func hideTabBarFrame(_ hide: Bool) {
        let showFrame = CGRect(x: 0, y: 618, width: 375, height: 49)
        let hideFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.tabBarController?.tabBar.isHidden = hide
        self.tabBarController?.tabBar.frame = hide ? hideFrame : showFrame
    }
    
    // MARK: - Animations
    
    func animateInputField(_ keyboardHeight: CGFloat, isShowing: Bool) {
        let deltaHeight = isShowing ? keyboardHeight : -(keyboardHeight)
        UIView.animate(withDuration: 0.4, animations: {
            self.inputContainerBottomConstraint.constant += deltaHeight
        }) 
    }
    
    /// Animates the bottom constraint of the input field for the keyboard showing
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        let keyboard = (((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        keyboardHeight = keyboard.height
        animateInputField(keyboardHeight, isShowing: true)
    }
    
    /// Animates the bottom constraint of the input field for the keyboard hiding
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        animateInputField(keyboardHeight, isShowing: false)
    }
    
    
    // MARK: - TextViewDelegate & Comment Creation
    
    /// Checks if a text view is empty
    func textViewIsEmpty(_ textView: UITextView) -> Bool {
        return textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    /// Changes the size of the height constraint for the container of the textView
    func changeTextViewSize(_ textView: UITextView) {
        let height = textView.contentSize.height
        let padding: CGFloat = 20
        if height <= 130 {
            self.inputContainerHeightConstraint.constant = height + padding
        }
    }
    
    /// Changes the textView size as user types
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textViewIsEmpty(textView) ? false : true
        changeTextViewSize(textView)
    }
    
    /// Creates a comment and any hashtags if they exist in the comment
    func createComment(_ text: String) {
        guard let currentUser = PFUser.current() else { return }
        guard let currentUsername = currentUser.username else { return }
        guard let postUniqueID = postUniqueID else { return }
        let avatar = currentUser.value(forKey: QueryKey.Avatar) as! PFFile
        let comment = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let date = Date()
        commentDataSource?.usernames.append(currentUsername)
        commentDataSource?.avatars.append(avatar)
        commentDataSource?.dates.append(date)
        commentDataSource?.comments.append(comment)
        tableView.reloadData()
        
        CommentService.createComment(withPostID: postUniqueID, andMessage: comment, commentOwner: commentOwner!) {
            self.tableView.reloadData()
        }
    }
    
    /// Resets the UI after a comment is created
    func resetUserInterface() {
        commentTextView.text = nil
        sendButton.isEnabled = false
        changeTextViewSize(self.commentTextView)
        view.endEditing(true)
    }
    
    @objc func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - IBActions
    
    @IBAction func usernamePressed(_ sender: UIButton) {
        guard let username = sender.titleLabel?.text else { return }
        NavigationManager.showProfileViewController(withPresenter: self, forUsername: username)
    }

    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        createComment(commentTextView.text)
        resetUserInterface()
    }
}


// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as? CommentCell ?? CommentCell()
        
        guard let postUniqueID = self.postUniqueID else { return [UITableViewRowAction]() }
        guard let commentDataSource = self.commentDataSource else { return [UITableViewRowAction]() }
        let comment = commentDataSource.comments[(indexPath as NSIndexPath).row]
        let username = commentDataSource.usernames[(indexPath as NSIndexPath).row]
        
        /// Deletes the comment
        let delete = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) in

            tableView.setEditing(false, animated: true)
            
            CommentService.deleteComment(withPostID: postUniqueID, messageToDelete: comment) {
                commentDataSource.comments.remove(at: (indexPath as NSIndexPath).row)
                commentDataSource.avatars.remove(at: (indexPath as NSIndexPath).row)
                commentDataSource.dates.remove(at: (indexPath as NSIndexPath).row)
                commentDataSource.usernames.remove(at: (indexPath as NSIndexPath).row)
                tableView.reloadData()
            }
            HashtagService.deleteHashtag(withID: postUniqueID, byUsername: username, forComment: comment)
            NotificationService.deleteNotification(username, owner: self.commentOwner!)
        }
        
        /// Adds the users name to text field as a mention
        let mention = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.commentTextView.text = "\(String(describing: self.commentTextView.text))" + "@" + "\(username)" + " "
            self.sendButton.isEnabled = true
            tableView.setEditing(false, animated: true)
        }
        
        /// Sends complaint about the comment to the server
        let complain = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) in
            tableView.setEditing(false, animated: true)
            ComplaintService.createComplaintFor(comment, withPostID: postUniqueID, reportedUser: username) {
                ErrorAlertService.displayAlertFor(.ComplaintSent, withPresenter: self)
            }
        }
        
        // Set background images for the actions
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "Delete")!)
        mention.backgroundColor = UIColor(patternImage: UIImage(named: "Mention")!)
        complain.backgroundColor = UIColor(patternImage: UIImage(named: "Complain")!)
        
        switch true {
        case cell.usernameButton.titleLabel?.text == PFUser.current()?.username:
            return [delete, mention]
        case self.commentOwner == PFUser.current()?.username:
            return [delete, mention, complain]
        default:
            return [mention, complain]
        }
    }
}
