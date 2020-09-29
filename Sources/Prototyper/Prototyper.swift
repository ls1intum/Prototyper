//
//  Prototyper.swift
//
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import UIKit
import PencilKit


/// Main class of the framework
public enum Prototyper {
    /// Prototyper settings is a struct that contains information about the configuration of the prototyper framework and is used for the initialization
    static var settings: PrototyperSettings = .default
    /// This class contains the information which are shared a cross the different classes
    static var currentState = PrototyperState(.default)
    
    
    /// The topmost View where the bubble was pressed.
    static var topViewController: UIViewController? {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return nil
        }
        
        var currentVC = rootViewController
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }
        return currentVC
    }
    
    
    /// Dismisses the topmost View.
    static func dismissView() {
        topViewController?.dismiss(animated: true, completion: nil)
    }
    
    /// Instantiates the screenshot variables with the screenshot of the current window
    static func takeScreenshot() {
        feedbackBubble.isHidden = true
        
        let screenshot = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?
            .screenshot ?? UIImage()
        
        feedbackBubble.isHidden = currentState.feedbackButtonIsHidden
        
        currentState.screenshot = screenshot
    }
    
    
    /// This static function is used to initialize the prototyper framework with a suitable `PrototyperSettings` object
    /// - Parameter settings: Struct that contains information about the configuration of the prototyper framework
    public static func configure(_ settings: PrototyperSettings) {
        self.currentState = PrototyperState(settings)
        self.settings = settings
        
        if settings.showFeedbackButton {
            addFeedbackBubble()
        }
    }
}
