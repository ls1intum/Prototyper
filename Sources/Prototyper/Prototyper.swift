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
class PrototyperState: ObservableObject {
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
    ///The APIHandler handels everything related to networking
    @Published var apiHandler: APIHandler!
    
    /// This boolean variable is used to check if the user is submitting feedback with or without logging in.
    var continueWithoutLogin: Bool {
        print("ContinueWithoutLogin set with \(apiHandler.continueWithoutLogin)")
        return apiHandler.continueWithoutLogin
    }
    /// This boolean variable is used to check if the user is logged in
    var userIsLoggedIn: Bool {
        print("UserisLoggedIn set with \(apiHandler.userIsLoggedIn)")
        return apiHandler.userIsLoggedIn
    }
    /// Initializer for the state
    /// - Parameter feedbackButtonIsHidden: Boolean whether the feedback button is shown
    init(_ settings: PrototyperSettings) {
        self.feedbackButtonIsHidden = !settings.showFeedbackButton
        apiHandler = APIHandler(prototyperInstance: settings.prototyperInstance, state: self)
    }
    
    ///Function to set FeedbackButtonIsHidden
    func setFeedbackButtonIsHidden(_ feedbackButtonIsHidden: Bool) {
        self.feedbackButtonIsHidden = feedbackButtonIsHidden
    }
    
    ///Function to set FeedbackButtonIsHidden depending on the PrototyperState
    func setFeedbackButtonIsHidden() {
        self.feedbackButtonIsHidden = !Prototyper.settings.showFeedbackButton
    }
    
    ///Returns the Screenshot if available
    func getScreenshot() -> UIImage {
        guard let screenshot = screenshot else {
            perror("Could not load the screenshot!")
            return UIImage()
        }
        return screenshot
    }
    
    ///Returns the Screenshot if available
    func getScreenshotWithMarkup() -> UIImage {
        guard let screenshotWithMarkup = screenshotWithMarkup else {
            perror("Could not load the screenshot!")
            return UIImage()
        }
        return screenshotWithMarkup
    }
    
//    func getContinueWithoutLogin() -> Bool {
//        return apiHandler.continueWithoutLogin
//    }
//
//    func getUserIsLoggedIn() -> Bool {
//        return apiHandler.userIsLoggedIn
//    }
//
    func setContinueWithoutLogin(_ bool: Bool) {
        apiHandler.continueWithoutLogin = bool
    }
    
    
}


/// Main class of the framework
public class Prototyper {
    /// Prototyper settings is a struct that contains information about the configuration of the prototyper framework and is used for the initialization
    static var settings: PrototyperSettings!
    /// This class contains the information which are shared a cross the different classes
    static var currentState: PrototyperState!
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
    
    @available(*, unavailable)
    private init() {
        fatalError("An instance of Prototyper should never be created")
    }
}
