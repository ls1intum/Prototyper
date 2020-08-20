//
//  Prototyper.swift
//
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import UIKit
import PencilKit

/// Prototyper settings is a struct that contains information about the configuration of the prototyper framework and is used for the initialization
public struct PrototyperSettings {
    /// The default setting establishes a connection to https://prototyper.ase.in.tum.de/login and shows the feedback button
    public static var `default`: PrototyperSettings = {
        PrototyperSettings(showFeedbackButton: true,
                           prototyperInstance: URL(string: "https://prototyper.ase.in.tum.de/login")!)
        // swiftlint:disable:previous force_unwrap
    }()
    
    
    /// Boolean whether the feedback button is shown
    public var showFeedbackButton: Bool
    /// URL for the prototyper instance
    public var prototyperInstance: URL
    
    
    /// The initializer to creat a new `PrototyperSettings` struct
    /// - Parameters:
    ///   - showFeedbackButton: Boolean if the feedback button is shown
    ///   - prototyperInstance: URL for the prototyper instance
    public init(showFeedbackButton: Bool = `default`.showFeedbackButton,
                prototyperInstance: URL = `default`.prototyperInstance) {
        self.showFeedbackButton = showFeedbackButton
        self.prototyperInstance = prototyperInstance
    }
}


/// This class contains the information which are shared a cross the different classes
public class PrototyperState: ObservableObject {
    /// Boolean whether the feedback button is shown
    @Published var feedbackButtonIsHidden: Bool
    /// The screenshot that should be displayed in the feedback view
    @Published var screenshot: UIImage? {
        didSet {
            screenshot.map { screenshotWithMarkup = $0 }
        }
    }
    /// The screenshot that should be displayed in the feedback view including the rendered markup
    @Published var screenshotWithMarkup: UIImage?
    /// This variable holds all the drawings the user draws in the Markup view.
    @Published var markupDrawings: PKDrawing?
    /// This boolean variable is used to check if the user is submitting feedback with or without logging in.
    @Published var continueWithoutLogin: Bool = false
    /// This boolean variable is used to check if the user is logged in
    @Published var userIsLoggedIn: Bool = false
    
    
    /// Initializer for the state
    /// - Parameter feedbackButtonIsHidden: Boolean whether the feedback button is shown
    init(feedbackButtonIsHidden: Bool) {
        self.feedbackButtonIsHidden = feedbackButtonIsHidden
    }
}


/// Main class of the framework
public class Prototyper {
    /// Prototyper settings is a struct that contains information about the configuration of the prototyper framework and is used for the initialization
    static var settings: PrototyperSettings!
    /// This class contains the information which are shared a cross the different classes
    static var currentState: PrototyperState!
    /// The apiHandler takes over all network tasks
    static var apiHandler: APIHandler!
    
    
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
        self.settings = settings
        
        self.currentState = PrototyperState(feedbackButtonIsHidden: !settings.showFeedbackButton)
        
        self.apiHandler = APIHandler(settings: settings)
        apiHandler.tryToFetchReleaseInfos()
        apiHandler.tryToLogin()
        
        if settings.showFeedbackButton {
            addFeedbackBubble()
        }
    }
    
    private init() {
        fatalError("An instance of Prototyper should never be created")
    }
}

