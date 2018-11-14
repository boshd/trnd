//
//  KeyboardObserver.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit

struct KeyboardObserver {
    
    // MARK: - Show
    
    static func startObservingWillShow(_ observer: AnyObject, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    static func endObservingWillShow(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    static func startObservingDidShow(_ observer: AnyObject, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    static func endObservingDidShow(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    // MARK: - Hide
    
    static func startObservingWillHide(_ observer: AnyObject, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    static func endObservingWillHide(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    static func startObservingDidHide(_ observer: AnyObject, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    static func endObservingDidHide(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}
