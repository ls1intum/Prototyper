//
//  KeyboardReactable.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 7/1/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol KeyboardReactable: class {
    @objc func keyboardWillShow(notification: NSNotification)
    @objc func keyboardWillHide(notification: NSNotification)
}

extension KeyboardReactable {
    public func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    public func animateKeyboardWillShow(_ notification: NSNotification, animation: @escaping (CGFloat) -> ()) {
        if let parameter = keyboardParameterFrom(notification: notification) {
            UIView.animate(withDuration: parameter.duration, delay: 0.0, options: parameter.animatorOption , animations: {
                animation(parameter.keyboardHeight)
            })
        }
    }
    
    public func animateKeyboardWillHide(_ notification: NSNotification, animation: @escaping () -> ()) {
        if let parameter = keyboardParameterFrom(notification: notification) {
            UIView.animate(withDuration: parameter.duration, delay: 0.0, options: parameter.animatorOption , animations: {
                animation()
            })
        }
    }
    
    private func keyboardParameterFrom(notification: NSNotification) -> (keyboardHeight: CGFloat, duration: Double, animatorOption: UIView.AnimationOptions)? {
        guard  let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationTime = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
                return nil
        }
        let animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.intValue<<16))
        return (keyboardSize.height, animationTime.doubleValue, animationOptions)
    }
}

extension UIViewController {
    public func adaptSafeAreaInserts(basedOnKeyboardHeight keyboardHeight: CGFloat) {
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets.bottom = 0.0
            self.additionalSafeAreaInsets.bottom = keyboardHeight - self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    public func adaptSafeAreaInserts() {
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets.bottom = 0.0
        }
    }
}
