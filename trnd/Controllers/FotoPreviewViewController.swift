//
//  FotoPreviewViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-09-09.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import FLAnimatedImage

class FotoPreviewViewController: UIViewController {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var blackView: UIView!
    
    var images: [UIImage] = []
    //var animatedImage: UIImage!
    var animatedImage: FLAnimatedImage!
    var gifURL: URL!
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        //let controller = FotoViewController()
        //controller.endCapture()
    }
    
    @IBAction func postAction(_ sender: Any) {
        self.view.bringSubviewToFront(blackView)
        self.view.bringSubviewToFront(indicator)
        blackView.isHidden = false
        indicator.isHidden = false
        indicator.startAnimating()
        
        //self.animatedImage = UIImage.animatedImage(with: self.images, duration: 4.0)
        //let data = UIImagePNGRepresentation(self.animatedImage)
        //let arrayData = NSKeyedArchiver.archivedData(withRootObject: self.images)
        //PostService.createPostWith(arrayData as NSData, title: "uhu", location: "", latitude: "", longitude: "", successBlock: {
        //    print("POSTED FROM THE PREVIEW CONTROLLER")
            
         //   self.blackView.isHidden = true
         //   self.indicator.isHidden = true
         //   self.navigationController?.popViewController(animated: false)
         //   let alertController = UIAlertController(title: "Gif.t posted!", message: "Posted to your feed.", preferredStyle: .alert)
         //   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         //   alertController.addAction(okAction)
         //   self.present(alertController, animated: true, completion: nil)
       // })
        
        PostService.createPostWith(gifURL, title: "halabzain", location: "", latitude: "", longitude: "") {
            print("POSTED FROM THE PREVIEW CONTROLLER")
            self.blackView.isHidden = true
            self.indicator.isHidden = true
            self.navigationController?.popViewController(animated: false)
            let alertController = UIAlertController(title: "Gif.t posted!", message: "Posted to your feed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackView.isHidden = true
        indicator.isHidden = true
        //self.animatedImage = UIImage.animatedImage(with: self.images, duration: 4.0)
        //self.imageView.animationImages = images
        //self.imageView.image = animatedImage
        //self.imageView.animationDuration = 1.0
        //self.imageView.startAnimating()
        
        do {
            try animatedImage = FLAnimatedImage(gifData: Data(contentsOf: gifURL))
        } catch {
            print("err from INSIDE FOTO PREV. \(error)")
        }
        
        self.animatedImageView.animatedImage = animatedImage

        print("\n\n\n\n\n\n \(gifURL)\n\n\n\n\n\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blackView.isHidden = true
        indicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blackView.isHidden = true
        indicator.isHidden = true
    }
    
}

//self.animatedImage = UIImage.animatedImage(with: self.images, duration: 4.0)
//let data = UIImagePNGRepresentation(self.animatedImage)
//let arrayData = NSKeyedArchiver.archivedData(withRootObject: self.images)
//PostService.createPostWith(arrayData as NSData, title: "uhu", location: "", latitude: "", longitude: "", successBlock: {
//    print("posted!!!trc")
//})
