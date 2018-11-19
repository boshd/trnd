//
//  PreviewViewController.swift
//  trnd
//
//  Created by Kareem Arab on 2018-11-18.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import FLAnimatedImage
import KRProgressHUD

class PreviewViewController: UIViewController {
    
    var animatedImage: FLAnimatedImage!
    var gifURL: URL!
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disappeared"), object: nil)
        setupTopBar()
        setupBottomBar()
        setupGesturesAndTargets()
        do {
            try animatedImage = FLAnimatedImage(gifData: Data(contentsOf: gifURL))
        } catch {
            print("err from INSIDE FOTO PREV. \(error)")
        }
        
        self.imageView.animatedImage = animatedImage
        
        print("\n\n\n\n\n\n \(gifURL)\n\n\n\n\n\n")

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(topBar)
        view.bringSubviewToFront(bottomBar)
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    func setupTopBar() {
        closeLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 40.0)
        closeLabel.textColor = .white
        closeLabel.text = String.fontAwesomeIcon("times")
        textLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 40.0)
        textLabel.textColor = .white
        textLabel.text = String.fontAwesomeIcon("font")
        
    }
    
    func setupBottomBar() {
        saveLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 40.0)
        saveLabel.textColor = .white
        saveLabel.text = String.fontAwesomeIcon("save")
        
        postLabel.font = UIFont.icon(from: .fontAwesome, ofSize: 40.0)
        postLabel.textColor = .white
        postLabel.text = String.fontAwesomeIcon("pluscircle")

    }
    
    func setupGesturesAndTargets() {
        let closeGR = UITapGestureRecognizer(target: self, action: #selector(self.closeAction))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(closeGR)
        
        let textGR = UITapGestureRecognizer(target: self, action: #selector(self.textAction))
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(textGR)

        let saveGR = UITapGestureRecognizer(target: self, action: #selector(self.saveAction))
        saveLabel.isUserInteractionEnabled = true
        saveLabel.addGestureRecognizer(saveGR)
        
        let postGR = UITapGestureRecognizer(target: self, action: #selector(self.postAction))
        postLabel.isUserInteractionEnabled = true
        postLabel.addGestureRecognizer(postGR)
    }
    
    @objc func closeAction(sender:UIGestureRecognizer) {
        print("pressed")
        dismiss(animated: false, completion: nil)
    }
    
    @objc func textAction(sender:UIGestureRecognizer) {
        
    }
    
    @objc func saveAction(sender:UIGestureRecognizer) {
        
    }
    
    @objc func postAction(sender:UIGestureRecognizer) {
        KRProgressHUD.show(withMessage: "Posting GIF..", completion: nil)
        PostService.createPostWith(gifURL, title: "😅😅😅😅", location: "", latitude: "", longitude: "") {
            
            print("POSTED FROM THE PREVIEW CONTROLLER")

            self.dismiss(animated: false, completion: {
                // replace with notification banner
                let alertController = UIAlertController(title: "GIF posted!", message: "Posted to your feed.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToFeed"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshData"), object: nil)
            })

        }
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}


