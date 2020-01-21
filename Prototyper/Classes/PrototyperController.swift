//
//  PrototyperController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import SwiftUI

open class PrototyperController: NSObject {
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
    
    fileprivate static var feedbackBubble: FeedbackBubble?
 
    static var continueWithoutLogin: Bool = false
    static var feedback: Feedback?
    
    // MARK: Computed Properties
    
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
    
    static var isFeedbackButtonHidden: Bool = false {
        didSet {
            if isFeedbackButtonHidden {
                feedbackBubble?.isHidden = true
            } else {
                feedbackBubble?.isHidden = false
            }
        }
    }
    
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
    
    private static func showFeedbackView() {
        /*let instantiatedViewController = UIStoryboard(name: "Feedback",
                                                      bundle: Bundle(for: FeedbackViewController.self)).instantiateInitialViewController()
        guard let navigationViewController = instantiatedViewController as? UINavigationController,
              let feedbackViewController = navigationViewController.topViewController as? FeedbackViewController else {
                return
        }
        
        isFeedbackButtonHidden = true
        feedbackViewController.screenshot = UIApplication.shared.keyWindow?.screenshot
        isFeedbackButtonHidden = false
        
        topViewController?.present(navigationViewController, animated: true, completion: nil) */
        let instantiatedViewController = UIHostingController(rootView: FeedbackView().environmentObject(Model()))
        instantiatedViewController.isModalInPresentation = true
        isFeedbackButtonHidden = true
        topViewController?.present(instantiatedViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Feedback Button Interaction
    
    private static func addFeedbackButton() {
        let keyWindow = UIApplication.shared.windows.filter{ $0.isKeyWindow }.first ?? UIApplication.shared.windows.first
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
    private static func shareApp() {
        let instantiatedViewController = UIHostingController(rootView: ShareView().environmentObject(Model()))
        instantiatedViewController.isModalInPresentation = true
        isFeedbackButtonHidden = true
        topViewController?.present(instantiatedViewController,
                                   animated: true,
                                   completion: nil)
    }
    
    static func dismissView() {
        topViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper
    
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
