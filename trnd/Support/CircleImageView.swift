//
//  CircleImageView.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    // MARK: - Properties
    
    @IBInspectable var borderThickness: CGFloat = 1.0 {
        didSet { setupBorderWidth() }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet { setupBorderColor() }
    }
    
    // MARK: - Drawing
    
    override func awakeFromNib() {
        setupView()
    }
    
    // MARK: - Methods: Internal
    
    /// Prepares the view for interface builder
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    // MARK: - Methods: Private
    
    /// Sets up the view for use
    fileprivate func setupView() {
        setupBorderWidth()
        setupBorderColor()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    /// Sets the layers borderWidth property with the borderThickness
    fileprivate func setupBorderWidth() {
        self.layer.borderWidth = borderThickness
    }
    
    /// Sets the layers borderColor property with the border
    fileprivate func setupBorderColor() {
        self.layer.borderColor = borderColor.cgColor
    }
}
