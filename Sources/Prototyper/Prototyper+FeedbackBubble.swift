//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import Combine
import UIKit


// MARK: Prototyper + Feedback Bubble
extension Prototyper {
    // MARK: Constants
    /// The Constants to be used to display the action sheet that is presented when pressing the feedback bubble
    private enum Constants {
        enum FeedbackActionSheet {
            static let title: String? = nil
            static let text: String? = nil
            static let writeFeedback = "Give feedback"
            static let shareApp = "Share app"
            static let hideFeedbackBubble = "Hide this button"
            static let cancel = "Cancel"
        }
    }
    
    
    private static var stateObservingCancellable: AnyCancellable?
    /// The static instance of the feedback bubble.
    static var feedbackBubble: FeedbackBubble = {
        let feedbackBubble = FeedbackBubble(action: showActionSheet)
        
        feedbackBubble.layer.zPosition = 100
        
        stateObservingCancellable = currentState.$feedbackButtonIsHidden
            .receive(on: RunLoop.main)
            .sink { feedbackButtonIsHidden in
                if feedbackButtonIsHidden {
                    UIView.animate(withDuration: 0.3,
                                   animations: {
                                    feedbackBubble.alpha = 0.0
                                   }, completion: { _ in
                                    feedbackBubble.isHidden = true
                                   })
                } else {
                    UIView.animate(withDuration: 0.3) {
                        feedbackBubble.isHidden = false
                        feedbackBubble.alpha = 1.0
                    }
                }
            }
        
        return feedbackBubble
    }()
    
    
    /// Displays the `FeedbackBubble` on the main window of the application
    static func addFeedbackBubble() {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIApplication.shared.windows.first
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            keyWindow?.addSubview(feedbackBubble)
        }
    }
    
    /// Displays the actions that the framework can perform.
    private static func showActionSheet(_ action: UIAction) {
        let actionSheet = UIAlertController(title: Constants.FeedbackActionSheet.title,
                                            message: Constants.FeedbackActionSheet.text,
                                            preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = feedbackBubble
        actionSheet.popoverPresentationController?.sourceRect = feedbackBubble.bounds
        
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.writeFeedback,
                                            style: .default) { _ in
            showFeedbackView()
        })
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.shareApp,
                                            style: .default) { _ in
            showShareApp()
        })
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.hideFeedbackBubble,
                                            style: .default) { _ in
            hideFeedbackButton()
        })
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.cancel,
                                            style: .cancel,
                                            handler: nil))
        
        topViewController?.present(actionSheet,
                                   animated: true,
                                   completion: nil)
    }
}
