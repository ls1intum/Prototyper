//
//  Prototyper.swift
//  
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import UIKit


/// <#Description#>
public struct PrototyperSettings {
    /// <#Description#>
    public static var `default`: PrototyperSettings = {
        PrototyperSettings(showFeedbackButton: true,
                           prototyperInstance: URL(string: "https://prototyper.ase.in.tum.de/login")!)
        // swiftlint:disable:previous force_unwrap
    }()
    
    
    /// <#Description#>
    public var showFeedbackButton: Bool
    /// <#Description#>
    public var prototyperInstance: URL
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - showFeedbackButton: <#showFeedbackButton description#>
    ///   - prototyperInstance: <#prototyperInstance description#>
    public init(showFeedbackButton: Bool = `default`.showFeedbackButton,
                prototyperInstance: URL = `default`.prototyperInstance) {
        self.showFeedbackButton = showFeedbackButton
        self.prototyperInstance = prototyperInstance
    }
}


/// <#Description#>
public class PrototyperState: ObservableObject {
    /// <#Description#>
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
    @Published var markupDrawings: [Drawing] = [Drawing]()
    /// This boolean variable is used to check if the user is submitting feedback with or without logging in.
    @Published var continueWithoutLogin: Bool = false
    
    
    /// <#Description#>
    /// - Parameter feedbackButtonIsHidden: <#feedbackButtonIsHidden description#>
    init(feedbackButtonIsHidden: Bool) {
        self.feedbackButtonIsHidden = feedbackButtonIsHidden
    }
}


/// <#Description#>
public class Prototyper {
    /// <#Description#>
    static var settings: PrototyperSettings!
    /// <#Description#>
    static var currentState: PrototyperState!
    /// <#Description#>
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
    
    
    /// <#Description#>
    /// - Parameter settings: <#settings description#>
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
