//
//  SearchCollectionDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse

class SearchCollectionDataSource: NSObject {
    
    // MARK: - Properties
    var collectionView: UICollectionView
    
    var files = [PFFile]()
    var uniqueIDs = [String]()
    var imagesToDownload = 15
    
    // MARK: - Initializer
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    // MARK: - Methods
    
    func downloadNewestPosts() {
        PostService.getNewestPosts(withLimit: imagesToDownload) { (uniqueIDs: [String], latitudes: [String], longitudes: [String], files: [PFFile]) in
            self.uniqueIDs.removeAll()
            self.files.removeAll()
            self.uniqueIDs.append(contentsOf: uniqueIDs)
            self.files.append(contentsOf: files)
            self.collectionView.reloadData()
        }
    }
    
    func loadMorePosts() {
        if imagesToDownload <= uniqueIDs.count {
            imagesToDownload += 15
            downloadNewestPosts()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uniqueIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        let file = files[(indexPath as NSIndexPath).row]
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: file) { (data: NSData) in
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data as Data) else { return }
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
                    imageView.image = image
                    imageView.contentMode = .scaleToFill
                    imageView.clipsToBounds = true
                    cell.addSubview(imageView)
                }
            }
        }
        return cell
    }
}
