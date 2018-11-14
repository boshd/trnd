//
//  OutlineButton.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

//@IBDesignable
final class OnboardButton: UIButton {
    
    // MARK: - Properties
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { setupCornerRadius() }
    }
    
    @IBInspectable var borderThickness: CGFloat = 1.0 {
        didSet { setupBorderThickness() }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet { setupBorderColor() }
    }
    
    // MARK: - Drawing
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Methods: Internal
    
    /// Configures the alpha and userInteraction for button
    func configureForState(_ isDisabled: Bool) {
        self.alpha = isDisabled ? 0.30 : 1.0
        self.isUserInteractionEnabled = isDisabled ? false : true
    }
    
    
    /// Prepares view in Interface Builder
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    // MARK: - Methods: Private
    
    /// Sets up the view for use
    fileprivate func setupView() {
        setupBorderThickness()
        setupBorderColor()
        setupCornerRadius()
    }
    
    /// Sets up the layers borderWidth property
    fileprivate func setupBorderThickness() {
        self.layer.borderWidth = borderThickness
    }
    
    /// Sets up the layers borderColor property
    fileprivate func setupBorderColor() {
        self.layer.borderColor = borderColor.cgColor
    }
    
    /// Sets up the layers cornerRadius property
    fileprivate func setupCornerRadius() {
        self.layer.cornerRadius = cornerRadius
    }
}
