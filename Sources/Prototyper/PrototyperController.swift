//
//  PrototyperController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import SwiftUI

/// This class handles the control flow of the tasks to be performed when the feedback button is pressed.
open class PrototyperController: NSObject {
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
    
    // MARK: Stored Properties
    /// The static instance of the feedback bubble.
    fileprivate static var feedbackBubble: FeedbackBubble?
    
    // MARK: Computed Properties
    /// Set to true when the application wants the feedback bubble to appear on the application.
    public static var showFeedbackButton: Bool = false {
        didSet {
            if showFeedbackButton {
                isFeedbackButtonHidden = false
                addFeedbackButton()
                APIHandler.tryToFetchReleaseInfos()
                APIHandler.tryToLogin()
            } else {
                isFeedbackButtonHidden = true
            }
        }
    }
    /// Static variable to swich between hiding and showing the feedback bubble.
    static var isFeedbackButtonHidden: Bool = false {
        didSet {
            if isFeedbackButtonHidden {
                feedbackBubble?.isHidden = true
            } else {
                feedbackBubble?.isHidden = false
            }
        }
    }
    /// The topmost View where the bubble was pressed.
    private static var topViewController: UIViewController? {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return nil
        }
        
        var currentVC = rootViewController
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }
        return currentVC
    }
    
    
    // MARK: - Static Methods
    // MARK: Show Feedback
    /// Displays the actions that the framework can perform.
    @objc private static func feedbackBubbleTouched() {
        let actionSheet = UIAlertController(title: Constants.FeedbackActionSheet.title,
                                            message: Constants.FeedbackActionSheet.text,
                                            preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = feedbackBubble
        actionSheet.popoverPresentationController?.sourceRect = feedbackBubble?.bounds ?? .zero
        
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.writeFeedback,
                                            style: .default) { _ in
            showFeedbackView()
        })
        actionSheet.addAction(UIAlertAction(title: Constants.FeedbackActionSheet.shareApp,
                                            style: .default) { _ in
            shareApp()
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
    
    /// Presents the FeedbackView as a UIHostingController
    private static func showFeedbackView() {
        let instantiatedViewController = UIHostingController(rootView: FeedbackView().environmentObject(Model()))
        instantiatedViewController.isModalInPresentation = true
        isFeedbackButtonHidden = true
        topViewController?.present(instantiatedViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Feedback Button Interaction
    /// Adds the feedback bubble to a specific position on the app window.
    private static func addFeedbackButton() {
        let keyWindow = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        
        feedbackBubble = feedbackBubble == nil ? FeedbackBubble(target: self,
                                                                action: #selector(feedbackBubbleTouched)) : feedbackBubble
        feedbackBubble?.layer.zPosition = 100
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let feedbackBubble = self.feedbackBubble else {
                return
            }
            keyWindow?.addSubview(feedbackBubble)
        }
    }
    
    /// Hides the Feedback bubble from the View.
    private static func hideFeedbackButton() {
        UIView.animate(withDuration: 0.3,
                       animations: {
            feedbackBubble?.alpha = 0.0
        }, completion: { _ in
            showFeedbackButton = false
            feedbackBubble?.alpha = 1.0
            
            showInfoAlertAfterHiding()
        })
    }
    
    // MARK: Share App
    ///Presents the ShareView as a UIHostingController.
    private static func shareApp() {
        let instantiatedViewController = UIHostingController(rootView: ShareView().environmentObject(Model()))
        instantiatedViewController.isModalInPresentation = true
        isFeedbackButtonHidden = true
        topViewController?.present(instantiatedViewController,
                                   animated: true,
                                   completion: nil)
    }
    
    /// Dismisses the topmost View.
    static func dismissView() {
        topViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper
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
