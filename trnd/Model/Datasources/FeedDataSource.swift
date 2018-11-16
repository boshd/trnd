//
//  FeedDataSource.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation
import FLAnimatedImage
import Foundation

class FeedDataSource: NSObject {
    
    // MARK: - Properties
    var tableView: UITableView
    
    var usersToShow = [String]()
    var postsToShow = 33
    
    var usernames = [String]()
    var avatars = [PFFile]()
    var postDescriptions = [String]()
    var locations = [String]()
    var latitudes = [String]()
    var longitudes = [String]()
    var postFiles = [PFFile]()
    var dates = [Date]()
    var uniqueIDs = [String]()

    
    // MARK: - Initializer
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Methods
    
    /// Downloads a single post with a postID
    func downloadPost(_ postID: String) {
        PostService.getPostWithUUID(uniqueID: postID) { (username: String, avatar: PFFile?, date: Date, postImg: PFFile, postText: String?, postLocation: String?, postLatitude: String?, postLongitude: String?) in
            // Clean up old data
            self.usernames.removeAll()
            self.postDescriptions.removeAll()
            self.locations.removeAll()
            self.latitudes.removeAll()
            self.longitudes.removeAll()
            self.postFiles.removeAll()
            self.dates.removeAll()
            self.avatars.removeAll()
            self.uniqueIDs.removeAll()

            
            // Add new data
            self.usernames.append(username)
            self.postFiles.append(postImg)
            self.dates.append(date)
            self.uniqueIDs.append(postID)
            self.latitudes.append(postLatitude!)
            self.longitudes.append(postLongitude!)
            
            if let avatar = avatar {
                self.avatars.append(avatar)
            }
            
            if let text = postText {
                self.postDescriptions.append(text)
            }
            
            if let loc = postLocation {
                self.locations.append(loc)
            }
            
            self.tableView.reloadData()
        }
    }
    
    /// Downloads all posts for current user and his/her followings
    func downloadAllPosts() {
        guard let currentUser = PFUser.current() else { return }
        guard let currentUsername = currentUser.username else { return }
        
        FollowService.getFollowingNamesFor(currentUsername) { (usernames: [String]) in
            self.usersToShow.removeAll()
            self.usersToShow.append(contentsOf: usernames)
            self.usersToShow.append(currentUsername)
            
            PostService.getPostsForNames(self.usersToShow, withLimit: self.postsToShow)
            { (usernames: [String], avatars: [PFFile], dates: [Date], postFiles: [PFFile], postDescriptions: [String], locations: [String], postLatitudes: [String], postLongitudes: [String], uniqueIDs: [String]) in
                
                self.usernames.removeAll()
                self.avatars.removeAll()
                self.dates.removeAll()
                self.postFiles.removeAll()
                self.postDescriptions.removeAll()
                self.locations.removeAll()
                self.latitudes.removeAll()
                self.longitudes.removeAll()
                self.uniqueIDs.removeAll()
                
                self.usernames = usernames
                self.avatars = avatars
                self.dates = dates
                self.postFiles = postFiles
                self.postDescriptions = postDescriptions
                self.locations = locations // ?
                self.latitudes = postLatitudes
                self.longitudes = postLongitudes
                self.uniqueIDs = uniqueIDs
                self.tableView.reloadData()
            }
        }
    }

}

extension FeedDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Check if post.count == 0 .. if yes, is it becuase there are no objects to show or it's because of a bad connection.
        if self.postFiles.count == 0 {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if delegate.reachability.isReachable == false {
                let noConLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)! ]
                let myString = NSMutableAttributedString(string: "No Internet Connection.", attributes: myAttribute )
                noConLabel.numberOfLines = 0
                noConLabel.attributedText = myString
                noConLabel.textAlignment = NSTextAlignment.center
                noConLabel.textColor = UIColor.lightGray
                noConLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.tableView.backgroundView = noConLabel
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                return 0
            } else if delegate.reachability.isReachable == true {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 22.0)! ]
                let myString = NSMutableAttributedString(string: "Follow others to see their \nposts. Start by tapping the \nTRND button above.", attributes: myAttribute )
                emptyLabel.numberOfLines = 0
                emptyLabel.attributedText = myString
                emptyLabel.textAlignment = NSTextAlignment.center
                emptyLabel.textColor = UIColor.lightGray
                emptyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.tableView.backgroundView = emptyLabel
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                return 0
            } else {
                return self.postFiles.count
            }
        } else {
            return self.postFiles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Reuse.PostCell, for: indexPath) as? PostCell ?? PostCell()
        //setupMentionTapHandler(cell)
        //setupHashtagMentionHandler(cell)
        
        let username = usernames[(indexPath as NSIndexPath).row]
        let description = postDescriptions[(indexPath as NSIndexPath).row]
        let location = locations[(indexPath as NSIndexPath).row]
        let latitude = latitudes[(indexPath as NSIndexPath).row]
        let longitude = longitudes[(indexPath as NSIndexPath).row]
        let date = dates[(indexPath as NSIndexPath).row]
        let avatarFile = avatars[(indexPath as NSIndexPath).row]
        let postFile = postFiles[(indexPath as NSIndexPath).row]
        let id = uniqueIDs[(indexPath as NSIndexPath).row]
        
        print("\(id)")
        
        //cell.configurePost(username, date: date, title: description, uniqueID: id, indexPath: indexPath)
        cell.configurePost(username, date: date, title: description, location: location, latitude: latitude, longitude: longitude, uniqueID: id, indexPath: indexPath)

        
        DispatchQueue.global(qos: .userInitiated).async {
            ParseOperation.getData(forFile: avatarFile) { (data: NSData) in
                guard let image = UIImage(data: data as Data) else { return }
                DispatchQueue.main.async {
                   cell.avatarImage.image = image
                }
            }
            
            ParseOperation.getData(forFile: postFile) { (data: NSData) in

                print("inisde get feed ^ heres the format")
                cell.animatedImageView.isHidden = false
                print("arrived safely")

                let animatedImage = FLAnimatedImage(gifData: data as Data)
                cell.animatedImageView.animatedImage = animatedImage

            }
            
            LikeService.userHasLikedPost(withUniqueID: id) { (hasLiked: Bool) in
                //let image = hasLiked ? UIImage(named: "Like") : UIImage(named: "Unlike")
                //let stringg = hasLiked ? "like" : "unlike"
                DispatchQueue.main.async {
                    //cell.likeButton.setImage(image, for: .normal)
                    //cell.likeButton.setTitle(stringg, for: UIControlState())
                }
            }
            
            LikeService.likeCountForPost(withUniqueID: id) { (count: Int) in
                DispatchQueue.main.async {
                    //cell.likeCountLabel.text = "\(count)"
                }
            }
        }
        return cell
    }
}

extension UIFont {
    func bold() -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
