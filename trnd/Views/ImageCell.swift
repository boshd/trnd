//
//  ImageCell.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import Parse
import FLAnimatedImage

class ImageCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var AnimatedImageView: FLAnimatedImageView!
    
    // Configures the image for the cell
    func configureWith(_ animatedImage: FLAnimatedImage, latitude: String, longitude: String) {
        self.AnimatedImageView.animatedImage = animatedImage
        self.AnimatedImageView.clipsToBounds = true
        print("IMAGE CELL")
        //self.latLabel.text = latitude
        //self.lonLabel.text = longitude
        //self.imageView.animationDuration = 2.5
        //self.imageView.startAnimating()
    }
}
