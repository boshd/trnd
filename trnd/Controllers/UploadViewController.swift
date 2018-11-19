//
//  UploadViewController.swift
//  trnd
//
//  Created by Kareem Arab on 2018-11-18.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import FLAnimatedImage

class UploadViewController: UIViewController, AMGifPickerDelegate, AMGifViewModelDelegate {
    
    var gifView: AMGifPicker!
    
    @IBAction func searchAction(_ sender: Any) {
        searchField.resignFirstResponder()
        gifView.search(searchField.text)
    }
    var imageView = FLAnimatedImageView()
    var gifModel: AMGifViewModel?
    var heightConstr: NSLayoutConstraint!
    var widthConstr: NSLayoutConstraint!
    
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let configuration = AMGifPickerConfiguration(apiKey: "64RLJtsFr7zEXrFbzsAetbduFJU3qpF6", direction: .horizontal)
        gifView = AMGifPicker(configuration: configuration)
        view.addSubview(gifView)
        gifView.translatesAutoresizingMaskIntoConstraints = false
        
        gifView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gifView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gifView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gifView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        gifView.delegate = self
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        heightConstr = imageView.heightAnchor.constraint(equalToConstant: 200)
        widthConstr = imageView.widthAnchor.constraint(equalToConstant: 200)
        heightConstr.isActive = true
        widthConstr.isActive = true
        
    }
    
    func gifPicker(_ picker: AMGifPicker, didSelected gif: AMGif) {
        let newGif = gif.translate(preferred: .low)
        
        gifModel = AMGifViewModel.init(newGif)
        gifModel?.delegate = self
        gifModel?.fetchData()
        
        heightConstr.constant = newGif.size.height
        widthConstr.constant = newGif.size.width
        
        //NavigationManager.showPreviewViewController(withPresenter: self, withGifUrl: <#T##URL#>)
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

