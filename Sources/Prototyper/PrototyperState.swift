//
//  PrototyperState.swift
//  
//
//  Created by Paul Schmiedmayer on 9/21/20.
//

import UIKit
import PencilKit


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
    @Published var apiHandler: APIHandler
    
    
    /// Initializer for the state
    /// - Parameter feedbackButtonIsHidden: Boolean whether the feedback button is shown
    init(_ settings: PrototyperSettings) {
        self.feedbackButtonIsHidden = !settings.showFeedbackButton
        apiHandler = APIHandler(prototyperInstance: settings.prototyperInstance)
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
}
