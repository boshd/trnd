//
//  HashtagDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import Parse
import FLAnimatedImage

class HashtagDataSource: NSObject {

    // MARK: - Properties
    var collectionView: UICollectionView
    var hashtag: String
    
    var files = [PFFile]()
    var uniqueIDs = [String]()
    var latitudes = [String]()
    var longitudes = [String]()
    var imagesToDownload = 15
    
    // MARK: - Initializer
    init(collectionView: UICollectionView, hashtag: String) {
        self.collectionView = collectionView
        self.hashtag = hashtag
        super.init()
    }
    
    // MARK: - Methods
    func downloadIDsForHashtag(_ completion: @escaping () -> Void) {
        HashtagService.retrieveUniqueIDsForHashtag(self.hashtag, withLimit: imagesToDownload) { (uniqueIDs: [String]) in
            self.uniqueIDs.removeAll()
            self.uniqueIDs.append(contentsOf: uniqueIDs)
            completion()
        }
    }
    
    func downloadPostsForHashtag() {
        
        PostService.getPostsWithUUIDs(uniqueIDs: self.uniqueIDs) { (uniqueIDs: [String], latitudes: [String], longitudes: [String], files: [PFFile]) in
            self.uniqueIDs.removeAll()
            self.latitudes.removeAll()
            self.longitudes.removeAll()
            self.files.removeAll()
            self.files.append(contentsOf: files)
            self.uniqueIDs.append(contentsOf: uniqueIDs)
            self.latitudes.append(contentsOf: latitudes)
            self.longitudes.append(contentsOf: longitudes)
            self.collectionView.reloadData()
        }
        
    }
    
    func loadMoreThumbs() {
        if imagesToDownload <= uniqueIDs.count {
            imagesToDownload += 15
            downloadIDsForHashtag() {
                self.downloadPostsForHashtag()
            }
        }
    }
}

extension HashtagDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Reuse.ImageCell, for: indexPath) as? ImageCell ?? ImageCell()
        let file = files[(indexPath as NSIndexPath).row]
        let lat = latitudes[(indexPath as NSIndexPath).row]
        let lon = longitudes[(indexPath as NSIndexPath).row]
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: file) { (data: NSData) in
                DispatchQueue.main.async {
                    
                    let animatedImage = FLAnimatedImage(gifData: data as Data)
                    cell.configureWith(animatedImage!, latitude: lat, longitude: lon)
                }
            }
        }
        return cell
    }
}
