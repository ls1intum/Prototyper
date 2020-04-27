//
//  Prototyper+HideFeedbackBubble.swift
//  
//
//  Created by Paul Schmiedmayer on 4/27/20.
//

import UIKit


// MARK: Prototyper + Feedback Bubble
extension Prototyper {
    // MARK: Constants
    /// The Constants to be used for the alert that is displayed after the feedback bubble is hidden
    private enum Constants {
        enum FeedbackHideAlertSheet {
            static let title = "To unhide the feedback button just close and open the app again."
            static let ok = "OK"
        }
    }
    
    
    /// Hides the Feedback bubble from the View and shows an alert after hiding the feedback bubble.
    public static func hideFeedbackButton() {
        settings.showFeedbackButton = false
        currentState.feedbackButtonIsHidden = true
        
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
