//
//  PostsViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
//import BetterSegmentedControl
import VBFPopFlatButton

// Controls the data being shown in the ProfileViewController
enum PostProfileMode {
    case currentUser
    case guest(String)
}

class PostsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    //var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var profileUsername: String?
    var profileMode: PostProfileMode = .currentUser
    var profileDataSource: ProfileDataSource?
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileDataSource()
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.downWeGo))
        swipeDown.delegate = self
        swipeDown.numberOfTouchesRequired = 1
        swipeDown.direction = .down
        self.collectionView!.addGestureRecognizer(swipeDown)
     
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    @objc func downWeGo() {
        
        if collectionView.contentOffset.y <= 64 {
            print("Swipe down recognized")
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController!.popViewController(animated: false)!
        }
        // holy shit this actually works .. so here's what i did for the record in case i died for someone to post it on stackoverflow. Anyway, what i wanted was to have a viewcontroller pushed INSDE a presented view controller which isnt possible right? So what I did was fake an animation (the exact same one above but reversed) to make it look like a presented view controller even though its a push. so it leads to this controller and to remove it you just swipe down and it makes sure youre at the top of the collection scroll view..
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadProfileData()
    }
    
    
    // MARK: - Methods
    

    
    /// Pops view controller off the navigation stack
    func backPressed() {
        self.navigationController?.popViewController(animated: false)
    }
    
    /// Sets up the ProfileDataSource
    func setupProfileDataSource() {
        profileDataSource = ProfileDataSource(collectionView: collectionView)
        collectionView.dataSource = profileDataSource
    }
    
    /// Downloads profile data
    func downloadProfileData() {
        switch profileMode {
        case .currentUser:
            profileDataSource?.downloadDataForCurrentUser()
        case .guest(let username):
            profileUsername = username
            profileDataSource?.downloadDataForGuest(username) {
                ErrorAlertService.displayAlertFor(.DoesNotExist, withPresenter: self)
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension PostsViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            profileDataSource?.downloadMorePosts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uniqueID = profileDataSource?.uniqueIDs[(indexPath as NSIndexPath).row] else { return }
        NavigationManager.showFeedViewController(withPresenter: self, forMode: FeedMode.singlePost(uniqueID))
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension PostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length: CGFloat = UIScreen.main.bounds.width / 2
        return CGSize(width: length, height: length)
    }
}
