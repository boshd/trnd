//
//  UploadViewController.swift
//  trnd
//
//  Created by Kareem Arab on 2018-11-18.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SwiftIconFont
import KRProgressHUD

class UploadViewController: UIViewController, AMGifPickerDelegate, AMGifViewModelDelegate {
    
    var gifView: AMGifPicker!
    var gifUrl: URL?
    var animatedImage: FLAnimatedImage!
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var browseView: UIView!
    @IBOutlet weak var viewerView: UIView!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchAction(_ sender: Any) {
        searchField.resignFirstResponder()
        gifView.search(searchField.text)
    }
    
    var imageView = FLAnimatedImageView()
    var gifModel: AMGifViewModel?
    var heightConstr: NSLayoutConstraint!
    var widthConstr: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesturesAndTargets()
        
        nextLabel.isHidden = true
        
        hideKeyboardWhenTappedAround()
        let configuration = AMGifPickerConfiguration(apiKey: "64RLJtsFr7zEXrFbzsAetbduFJU3qpF6", direction: .horizontal)
        gifView = AMGifPicker(configuration: configuration)
        browseView.addSubview(gifView)
        gifView.translatesAutoresizingMaskIntoConstraints = false
        
        gifView.leftAnchor.constraint(equalTo: browseView.leftAnchor).isActive = true
        gifView.rightAnchor.constraint(equalTo: browseView.rightAnchor).isActive = true
        gifView.bottomAnchor.constraint(equalTo: browseView.bottomAnchor).isActive = true
        gifView.topAnchor.constraint(equalTo: browseView.topAnchor).isActive = true
        //gifView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        //gifView.contentMode = .topLeft
        gifView.delegate = self
        //gifView.contentMode = .scaleToFill
        
        //viewerView.addSubview(imageView)
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //imageView.leftAnchor.constraint(greaterThanOrEqualTo: viewerView.leftAnchor).isActive = true
        //imageView.rightAnchor.constraint(lessThanOrEqualTo: viewerView.rightAnchor).isActive = true
        //imageView.centerXAnchor.constraint(equalTo: viewerView.centerXAnchor).isActive = true
        //imageView.topAnchor.constraint(equalTo: viewerView.topAnchor).isActive = true
        //imageView.contentMode = .scaleAspectFit
        //heightConstr = imageView.heightAnchor.constraint(equalToConstant: 200)
        //widthConstr = imageView.widthAnchor.constraint(equalToConstant: 200)
        //heightConstr.isActive = true
        //widthConstr.isActive = true
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func setupUI() {
        closeLabel.font = UIFont.icon(from: .ionicon, ofSize: 50.0)
        closeLabel.textColor = .white
        closeLabel.text = String.fontIonIcon("ios-close")
        closeLabel.isHidden = false
        
        nextLabel.layer.cornerRadius = 25
        nextLabel.font = UIFont.icon(from: .ionicon, ofSize: 50.0)
        nextLabel.textColor = .white
        nextLabel.text = String.fontIonIcon("ios-done-all")
        nextLabel.isHidden = false
        
        searchButton.layer.cornerRadius = 15
    }
    
    func setupGesturesAndTargets() {
        let closeGR = UITapGestureRecognizer(target: self, action: #selector(self.closeAction))
        closeLabel.isUserInteractionEnabled = true
        closeLabel.addGestureRecognizer(closeGR)
        
        let nextGR = UITapGestureRecognizer(target: self, action: #selector(self.nextAction))
        nextLabel.isUserInteractionEnabled = true
        nextLabel.addGestureRecognizer(nextGR)
    }
    
    @objc func closeAction(sender:UIGestureRecognizer) {
        print("pressed")
        dismiss(animated: false, completion: nil)
    }
    
    @objc func nextAction(sender:UIGestureRecognizer) {
        if let url = gifUrl {
            NavigationManager.showPreviewViewController(withPresenter: self, withGifUrl: url)
        } else {
            print("no gif selected dumbass")
            KRProgressHUD.showError(withMessage: "No GIF selected.")
        }
    }
    
    func gifPicker(_ picker: AMGifPicker, didSelected gif: AMGif) {
        let newGif = gif.translate(preferred: .original)
        
        nextLabel.isHidden = false
        
        gifModel = AMGifViewModel.init(newGif)
        gifModel?.delegate = self
        gifModel?.fetchData()
        
        let urlstring = gif.gifUrl
        let url = NSURL(string: urlstring)
        print("the url = \(url!)")
        gifUrl = (url! as URL)
        
        do {
            try animatedImage = FLAnimatedImage(gifData: Data(contentsOf: gifUrl!))
        } catch {
            print("err from INSIDE FOTO PREV. \(error)")
        }
        
        self.animatedImageView.animatedImage = animatedImage
        //heightConstr.constant = newGif.size.height
        //widthConstr.constant = newGif.size.width
        
        
    }
    
    func giphyModelDidBeginLoadingThumbnail(_ item: AMGifViewModel?) {}
    func giphyModelDidEndLoadingThumbnail(_ item: AMGifViewModel?) {}
    func giphyModelDidBeginLoadingGif(_ item: AMGifViewModel?) {}
    
    func giphyModel(_ item: AMGifViewModel?, thumbnail data: Data?) {
        imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
    }
    
    func giphyModel(_ item: AMGifViewModel?, gifData data: Data?) {
        imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
    }
    
    func giphyModel(_ item: AMGifViewModel?, gifProgress progress: CGFloat) {}
    
}
