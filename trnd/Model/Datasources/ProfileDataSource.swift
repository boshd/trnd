//
//  ProfileDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation
import Photos
import FLAnimatedImage

class ProfileDataSource: NSObject {
    
    //  Properties
    var collectionView: UICollectionView
    var profileOwner: PFUser?
    
    // Posts
    var imagesToLoad = 9
    var uniqueIDs = [String]()
    var latitudes = [String]()
    var longitudes = [String]()
    var files = [PFFile]()
    
    
    // Initialise
    
    /// Initializer for guest user
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    

    func downloadDataForCurrentUser() {
        guard let currentUser = PFUser.current() else { return }
        self.profileOwner = currentUser
        
        guard let currentName = currentUser.username else { return }
        self.getPostsForUser(currentName, withLimit: imagesToLoad)
    }

    func downloadDataForGuest(_ name: String, onFailure: @escaping () -> Void) {
        getPostsForUser(name, withLimit: imagesToLoad)
        UserService.getUserWithName(name) { (user: PFUser?, success: Bool) in
            if success {
                self.profileOwner = user
                self.collectionView.reloadData()
            } else {
                onFailure()
            }
        }
    }
    
    fileprivate func getPostsForUser(_ name: String, withLimit limit: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            PostService.getPostsForName(name, withLimit: limit) { (uniqueIDs: [String], latitudes: [String], longitudes: [String], files: [PFFile]) in
                self.uniqueIDs.removeAll()
                self.latitudes.removeAll()
                self.longitudes.removeAll()
                self.files.removeAll()
                self.uniqueIDs.append(contentsOf: uniqueIDs)
                self.latitudes.append(contentsOf: latitudes)
                self.longitudes.append(contentsOf: longitudes)
                self.files.append(contentsOf: files)
                self.collectionView.reloadData()
            }
        }
    }
    
    // Download more posts - used when user scrolls
    func downloadMorePosts() {
        guard let username = profileOwner?.username else { return }
        if imagesToLoad <= uniqueIDs.count {
            imagesToLoad += 15
            getPostsForUser(username, withLimit: imagesToLoad)
        }
    }
}


extension ProfileDataSource: UICollectionViewDataSource {
    
    
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Check if files.count == 0 .. if yes, is it becuase there are actually no objects to show or is it because of a bad/no connection.
        if self.files.count == 0 {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.reachability.isReachable == false {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20.0)! ]
                let myString = NSMutableAttributedString(string: "\n\n\n\n\n\n\n\nNo internet.. :/\n Connect to the internet and\ntry again.", attributes: myAttribute )
                emptyLabel.numberOfLines = 0
                emptyLabel.attributedText = myString
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.collectionView.backgroundView = emptyLabel
                return 0
            } else if delegate.reachability.isReachable == true {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 20.0)! ]
                let myString = NSMutableAttributedString(string: "\n\n\n\n\n\n\n\n", attributes: myAttribute )
                emptyLabel.numberOfLines = 0
                emptyLabel.attributedText = myString
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.collectionView.backgroundView = emptyLabel
                return 0
            } else {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20.0)! ]
                let myString = NSMutableAttributedString(string: "", attributes: myAttribute )
                emptyLabel.numberOfLines = 0
                emptyLabel.attributedText = myString
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.collectionView.backgroundView = emptyLabel
                return self.files.count
            }
        } else {
            return self.files.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("HEY 1")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Reuse.ImageCell, for: indexPath) as? ImageCell ?? ImageCell()
        print("HEY 2")
        
        let file = files[(indexPath as NSIndexPath).row]
        _ = latitudes[(indexPath as NSIndexPath).row]
        _ = longitudes[(indexPath as NSIndexPath).row]
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: file) { (data: NSData) in
                DispatchQueue.main.async {

                    let animatedImage = FLAnimatedImage(gifData: data as Data)
                    cell.configureWith(animatedImage!, latitude: "", longitude: "")
                    cell.AnimatedImageView.animatedImage = animatedImage
                    
                }
            }
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: file) { (data: NSData) in
                DispatchQueue.main.async {
                    print("Gif file found.")
                    //guard let gif = FLAnimatedImage(gifData: data as Data!) else {return}
                    //cell.AnimatedImageView.animatedImage = gif
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Reuse.ProfileHeader, for: indexPath) as? ProfileHeader ?? ProfileHeader()
        
        guard let user = profileOwner else { return header}
        guard let username = user.username else { return header }
        
        header.configure(forUser: user)
        
        DispatchQueue.global(qos: .userInitiated).async {
            UserService.getAvatarImgForUser(user) { (image: UIImage) in
                DispatchQueue.main.async {
                    
                    header.profileImage.image = image
                    
                }
            }
            
            FollowService.getFollowerCount(username) { (count: Int32) in
                DispatchQueue.main.async {
                    header.totalFollowersLabel.text = "\(count)"
                }
            }
            
            FollowService.getFollowingCount(username) { (count: Int32) in
                DispatchQueue.main.async {
                    header.totalFollowingLabel.text = "\(count)"
                }
            }
            
            FollowService.isUserFollowing(username) { (following: Bool) in
                DispatchQueue.main.async {
                    header.configureButton(user, isFollowing: following)
                }
            }
        }
        
        return header
    }
    
}
