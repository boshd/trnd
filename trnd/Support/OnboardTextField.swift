//
//  BlurredTextField.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

final class OnboardTextField: UITextField {
    
    // MARK: - Properties
    
    @IBInspectable var inset: CGFloat = 0
    
    @IBInspectable var placeHolderTextColor: UIColor = UIColor.lightGray {
        didSet { setupPlaceholderTextColor() }
    }
    
    @IBInspectable var blurIntensity: CGFloat = 0.3 {
        didSet { setupBlurIntensity() }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet { setupCornerRadius() }
    }
    
    // MARK: - Drawing
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Methods: Internal
    
    /// Adjusts the insets of the textRect
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    /// Adjusts the insets of the textRect while editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    /// Prepares the view for Interface Builder
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    // MARK: - Methods: Private
    
    /// Sets up view for use
    fileprivate func setupView() {
        setupCornerRadius()
        setupBlurIntensity()
        setupPlaceholderTextColor()
    }
    
    /// Sets the views cornerRadius property
    fileprivate func setupCornerRadius() {
        self.layer.cornerRadius = cornerRadius
    }
    
    /// Sets the background color of view to white, using blur intensity as alpha value
    fileprivate func setupBlurIntensity() {
        let color = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: blurIntensity)
        self.backgroundColor = color
    }
    
    /// Sets the color of the placeholder text
    fileprivate func setupPlaceholderTextColor() {
        let text = self.placeholder ?? ""
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: placeHolderTextColor])
    }
}
