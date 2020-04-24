//
//  FeedbackBubble.swift
//  Prototyper
//
//  Created by Stefan Kofler on 17.10.16.
//  Copyright (c) 2016 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

/// A static instance of this class is created to place the feedback bubble on app start.
class FeedbackBubble: UIView {
    /// The size of the feedback bubble in CGSize.
    private static var size = CGSize(width: 70, height: 70)
    
    init(target: Any, action: Selector) {
        super.init(frame: CGRect(x: -FeedbackBubble.size.width / 2,
                                 y: UIScreen.main.bounds.size.height / 2,
                                 width: FeedbackBubble.size.width,
                                 height: FeedbackBubble.size.height))
        
        let feedbackButton = UIButton(type: .custom)
        setBubbleImageToButton(button: feedbackButton)
        feedbackButton.frame = CGRect(x: 0, y: 0, width: FeedbackBubble.size.width, height: FeedbackBubble.size.height)
        feedbackButton.addTarget(target, action: action, for: .touchUpInside)
        addShadow(view: feedbackButton)
        self.addSubview(feedbackButton)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(recognizer:)))
        self.gestureRecognizers = [panRecognizer]
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        self.center = recognizer.location(in: self.superview)
        let superViewWidth = self.superview?.bounds.size.width ?? 0
        let superViewHeight = self.superview?.bounds.size.height ?? 0
        
        if recognizer.state == .ended {
            let endPositionX: CGFloat
            if self.center.x <= superViewWidth / 2 {
                endPositionX = -FeedbackBubble.size.width / 2
            } else {
                endPositionX = superViewWidth - FeedbackBubble.size.width / 2
            }
            
            let detectedVelocity = recognizer.velocity(in: self.superview).y
            let velocity: CGFloat = abs(detectedVelocity) > 100 ? (detectedVelocity > 0 ? 50 : -50) : 0
            let endPositionY = min(max(0, self.frame.origin.y + velocity), superViewHeight - FeedbackBubble.size.height)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.frame.origin.x = endPositionX
                self.frame.origin.y = endPositionY
            }, completion: nil)
        }
    }
    
    /// Sets the image to the Feedback bubble
    private func setBubbleImageToButton(button: UIButton) {
        let backgroundCircle = UIImage(systemName: "circle.fill",
                                       withConfiguration: UIImage.SymbolConfiguration(pointSize: 70, weight: .heavy))?
            .withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        
        let shareIcon = UIImage(systemName: "square.and.arrow.up",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light))?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        guard let backgroundCircleImage = backgroundCircle, let shareIconImage = shareIcon else {
            return
        }
        
        let feedbackIcon = UIImage.overlapImages(topImage: shareIconImage, bottomImage: backgroundCircleImage)
        button.setImage(feedbackIcon, for: .normal)
    }
    
    /// Adds shadow to the feedback bubble
    private func addShadow(view: UIView) {
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
}
