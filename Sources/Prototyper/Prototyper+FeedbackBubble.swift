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
    /// The Constants to be used when alerts and sheets are presented via the feedback bubble.
    enum Constants {
        enum FeedbackHideAlertSheet {
            static let title = "To unhide the feedback button just close and open the app again."
            static let ok = "OK"
        }
        
        enum FeedbackActionSheet {
            static let title: String? = nil
            static let text: String? = nil
            static let writeFeedback = "Give feedback"
            static let shareApp = "Share app"
            static let hideFeedbackBubble = "Hide this button"
            static let cancel = "Cancel"
        }
    }
    
    
    /// <#Description#>
    private static var stateObservingCancellable: AnyCancellable?
    /// The static instance of the feedback bubble.
    private static var feedbackBubble: FeedbackBubble = {
        let feedbackBubble = FeedbackBubble(target: Prototyper.self,
                                            action: #selector(showActionSheet))

        feedbackBubble.layer.zPosition = 100
        
        stateObservingCancellable = currentState.objectWillChange
            .sink {
                if currentState.feedbackButtonIsHidden {
                    UIView.animate(withDuration: 0.3) {
                        feedbackBubble.alpha = 0.0
                        feedbackBubble.isUserInteractionEnabled = false
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        feedbackBubble.alpha = 1.0
                        feedbackBubble.isUserInteractionEnabled = true
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
    @objc private static func showActionSheet() {
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
    
    /// Hides the Feedback bubble from the View.
    private static func hideFeedbackButton() {
        UIView.animate(withDuration: 0.3,
                       animations: {
            feedbackBubble.alpha = 0.0
            feedbackBubble.isUserInteractionEnabled = false
        }, completion: { _ in
            currentState.feedbackButtonIsHidden = true
            showInfoAlertAfterHiding()
        })
    }
    
    /// Shows an alert after hiding the feedback bubble.
    private static func showInfoAlertAfterHiding() {
        guard let rootViewController = topViewController else {
            return
        }
        
        let alertController = UIAlertController(title: Constants.FeedbackHideAlertSheet.title,
                                                message: nil,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.FeedbackHideAlertSheet.ok,
                                                style: .default,
                                                handler: nil))
        rootViewController.present(alertController,
                                   animated: true,
                                   completion: nil)
    }
}
