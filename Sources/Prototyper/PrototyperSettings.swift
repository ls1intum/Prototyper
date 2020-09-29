//
//  PrototyperSettings.swift
//  
//
//  Created by Paul Schmiedmayer on 9/21/20.
//

import Foundation


/// Prototyper settings is a struct that contains information about the configuration of the prototyper framework and is used for the initialization
public struct PrototyperSettings {
    /// The default setting establishes a connection to https://prototyper.ase.in.tum.de/login and shows the feedback button
    public static var `default`: PrototyperSettings = {
        PrototyperSettings(showFeedbackButton: true,
                           prototyperInstance: URL(string: "https://prototyper.ase.in.tum.de/login")!)
        // swiftlint:disable:previous force_unwrapping
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
