//
//  Prototyper.swift
//  
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import Foundation
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
    /// - Parameter settings: <#settings description#>
    static func configure(_ settings: PrototyperSettings) {
        self.settings = settings
        
        self.currentState = PrototyperState(feedbackButtonIsHidden: !settings.showFeedbackButton)
        
        APIHandler.tryToFetchReleaseInfos()
        APIHandler.tryToLogin()
    }
    
    
    private init() {
        fatalError("An instance of Prototyper should never be created")
    }
    
    
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
}
