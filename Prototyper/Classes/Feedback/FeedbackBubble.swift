//
//  FeedbackBubble.swift
//  Prototyper
//
//  Created by Stefan Kofler on 17.10.16.
//  Copyright (c) 2016 Stefan Kofler. All rights reserved.
//

import Foundation

class FeedbackBubble: UIView {
    private static var size = CGSize(width: 70, height: 70)
    
    init(target: Any, action: Selector) {
        super.init(frame: CGRect(x: -FeedbackBubble.size.width/2, y: UIScreen.main.bounds.size.height/2, width: FeedbackBubble.size.width, height: FeedbackBubble.size.height))
        
        let feedbackButton = UIButton(type: .custom)
        feedbackButton.setImage(UIImage(named: "feedback_icon", in: Bundle(for: PrototyperController.self), compatibleWith: nil), for: .normal)
        feedbackButton.frame = CGRect(x: 0, y: 0, width: FeedbackBubble.size.width, height: FeedbackBubble.size.height)
        feedbackButton.addTarget(target, action: action, for: .touchUpInside)
        self.addSubview(feedbackButton)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(detectPan(recognizer:)))
        self.gestureRecognizers = [panRecognizer]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        self.center = recognizer.location(in: self.superview)
        let superViewWidth = self.superview?.bounds.size.width ?? 0
        let superViewHeight = self.superview?.bounds.size.height ?? 0
        
        if recognizer.state == .ended {
            let endPositionX: CGFloat
            if self.center.x <= superViewWidth/2 {
                endPositionX = -FeedbackBubble.size.width/2
            } else {
                endPositionX = superViewWidth-FeedbackBubble.size.width/2
            }
            
            let detectedVelocity = recognizer.velocity(in: self.superview).y
            let velocity: CGFloat = abs(detectedVelocity) > 100 ? (detectedVelocity > 0 ? 50 : -50) : 0
            let endPositionY = min(max(0, self.frame.origin.y + velocity), superViewHeight-FeedbackBubble.size.height)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
                self.frame.origin.x = endPositionX
                self.frame.origin.y = endPositionY
            }, completion: nil)
        }
    }
    
}
