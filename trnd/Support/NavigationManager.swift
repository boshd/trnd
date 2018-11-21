//
//  NavigationManager.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

public struct NavigationManager {
    
    // MARK: - App Delegate
    
    static func setRootViewController(ofWindow window: UIWindow?) {
        if UserDefaults.standard.value(forKey: DEFAULTS_USERNAME) == nil {
            Storyboard.onboardNavigationController().popViewController(animated: true)
            
            window?.rootViewController = Storyboard.onboardNavigationController()
        } else {
            //window?.rootViewController = Storyboard.titleViewController()
            window?.rootViewController = Storyboard.mainController()
        }
    }
    
    static func setRootViewControllerFirstTime(ofWindow window: UIWindow?) {
        if UserDefaults.standard.value(forKey: DEFAULTS_USERNAME) == nil {
            window?.rootViewController = Storyboard.onboardNavigationController()
        } else {
            //window?.rootViewController = Storyboard.titleViewController()
            window?.rootViewController = Storyboard.mainControllerFirstTime()
        }
    }
    
    // MARK: - Onboard

    
    /// Presents the sign in view controller
    static func showSignInViewController(withPresenter presenter: UIViewController) {
       let controller = Storyboard.signInViewController()
        presenter.present(controller, animated: true, completion: nil)
    }
    
    /// Presents the provide email sign up view controller
    static func showEmailSignUpViewController(withPresenter presenter: UIViewController) {
        let controller = Storyboard.signUpEmailViewController()
        presenter.present(controller, animated: true, completion: nil)
    }
    
    /// Presents the show signup details view controller and passes the provided email
    static func showSignUpDetailsViewController(withPresenter presenter: UIViewController, andEmail email: String) {
        let controller = Storyboard.signUpDetailsViewController()
        presenter.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Main Application
    
    /// Presents the profile view controller for a given username and pushes it onto the MainNavigationController stack
    static func showProfileViewController(withPresenter presenter: UIViewController, forUsername username: String) {
        let controller = Storyboard.profileViewController()
        guard let navigationController = presenter.navigationController else { return }
        let profileMode: ProfileMode = username == PFUser.current()?.username ? .currentUser : .guest(username)
        controller.profileMode = profileMode
        //presenter.present(controller, animated: true, completion: nil)
        //navigationController.pushViewController(controller, animated: false)
        navigationController.present(controller, animated: true, completion: nil)
    }
    
    /// Presents the posts view controller for a given username and pushes it onto the MainNavigationController stack
    static func showPostsViewController(withPresenter presenter: UIViewController, forUsername username: String) {
        let controller = Storyboard.postsViewController()
        guard let navigationController = presenter.navigationController else { return }
        
        let profileMode: PostProfileMode = username == PFUser.current()?.username ? .currentUser : .guest(username)
        controller.profileMode = profileMode
        
        navigationController.present(controller, animated: true)
    }
    
    /// Presents the follow view controller for a follow mode and pushes it onto the MainNavigationController stack
    static func showFollowViewController(withPresenter presenter: UIViewController, forMode mode: FollowMode) {
        let controller = Storyboard.followViewController()
        guard let navigationController = presenter.navigationController else { return }
        controller.followMode = mode
        //navigationController.navigationBar.tintColor = UIColor.blue
        navigationController.present(controller, animated: true)
    }
    
    /// Presents the feed view controller for a follow mode and pushes it onto the MainNavigationController stack
    static func showFeedViewController(withPresenter presenter: UIViewController, forMode mode: FeedMode) {
        let controller = Storyboard.feedViewController()
        controller.feedMode = mode
        guard let navigationController = presenter.navigationController else { return }
        //navigationController.pushViewController(controller, animated: true)
        navigationController.present(controller, animated: true, completion: nil)
        //navigationController.pushViewController(controller, animated: true)
        
    }
    

    
    /// Presents the foto preview view controller for a follow mode and pushes it onto the MainNavigationController stack
    static func showPreviewViewController(withPresenter presenter: UIViewController, withGifUrl gifUrl: URL?) {
        
        let controller = Storyboard.previewViewController()
        controller.gifURL = gifUrl!
        print(gifUrl!)
        print("called 1")
//        guard let navigationController = presenter.navigationController else {
//            return
//        }
        
        presenter.present(controller, animated: false, completion: {
            print("called3")
        })
        //navigationController.present(controller, animated: false, completion: nil)
        //
        
        //navigationController.present(controller, animated: false, completion: nil)
        
    }
    
    /// Presents the comment view controller with commentID and commentOwner
    static func showCommentViewController(withPresenter presenter: UIViewController, postID: String, commentOwner: String) {
        let controller = Storyboard.commentViewController()
        controller.postUniqueID = postID
        controller.commentOwner = commentOwner
        guard let navigationController = presenter.navigationController else { return }
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.present(controller, animated: true, completion: nil)
        //navigationController.pushViewController(controller, animated: true)
    }
    
    /// Presents the hashtag view controller for a hashtag
    static func showHashtagViewController(withPresenter presenter: UIViewController, hashtag: String) {
        let controller = Storyboard.hashtagViewController()
        controller.hashtag = hashtag
        guard let navigationController = presenter.navigationController else { return }
        navigationController.pushViewController(controller, animated: true)
    }
    
    // MARK: - Settings
    
    /// Presents the settings view controller
    static func showSettingsViewController(withPresenter presenter: UIViewController) {
        let controller = Storyboard.settingsViewController()
        presenter.present(controller, animated: true, completion: nil)
        
    }
    
}
