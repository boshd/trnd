//
//  HashtagViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse
import MapKit
import CoreLocation

class HashtagViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var hashtag: String?
    var hashtagDataSource: HashtagDataSource?
    let annotation = MKPointAnnotation()
    let centerCoordinate = CLLocationCoordinate2D(latitude: 41, longitude:29)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHashtagDataSource()
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadThumbsForHashtag()
    }
    
    // MARK: - Methods
    
    func hello() {
        //
        annotation.coordinate = centerCoordinate
        annotation.title = "Title"
        mapView.addAnnotation(annotation)
        
        let query: PFQuery = PFUser.query()!
        
        query.whereKey(hashtag!, containedIn: [QueryKey.Hashtag])
        
        
        
    }
    
    /// Sets up the HashtagDataSource
    func setupHashtagDataSource() {
        guard let hashtag = hashtag else { return }
        hashtagDataSource = HashtagDataSource(collectionView: collectionView, hashtag: hashtag)
        collectionView.dataSource = hashtagDataSource
    }
    
    /// Downloads all the thumbs for the hashtag
    func downloadThumbsForHashtag() {
        guard let hashtagDataSource = hashtagDataSource else { return }
        hashtagDataSource.downloadIDsForHashtag() {
            hashtagDataSource.downloadPostsForHashtag()
        }
    }
    
    /// Set up user interface
    func setupUserInterface() {
        if let hashtag = hashtag {
            self.navigationItem.title = "#\(hashtag.uppercased())"
        }
        let backButton = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(HashtagViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HashtagViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 3 {
            hashtagDataSource?.loadMoreThumbs()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hashtagDataSource = hashtagDataSource else { return }
        let postID = hashtagDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
        NavigationManager.showFeedViewController(withPresenter: self, forMode: .singlePost(postID))
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension HashtagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length: CGFloat = UIScreen.main.bounds.width / 3
        return CGSize(width: length, height: length)
    }
}
