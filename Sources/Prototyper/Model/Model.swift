//
//  Model.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import Foundation
import SwiftUI


// MARK: Model
/// An instance of this class is to be used inside views, so that when the Published variable values change, the view will reload.
class Model: ObservableObject {
    /// Instantiates the screenshot variables with the screenshot of the first View when the feedback Bubble was pressed.
    static func getScreenShot() -> UIImage {
        PrototyperController.isFeedbackButtonHidden = true
        let screenshot = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?
            .screenshot ?? UIImage()
        
        PrototyperController.isFeedbackButtonHidden = false
        
        return screenshot
    }
    
    /// The markup colors provided to draw on the EditScreenshotView
    static let markupColors: [MarkupColor] = [
        MarkupColor(displayName: "Black", color: Color.black),
        MarkupColor(displayName: "Red", color: Color.red),
        MarkupColor(displayName: "Blue", color: Color.blue),
        MarkupColor(displayName: "Yellow", color: Color.yellow),
        MarkupColor(displayName: "Green", color: Color.green),
        MarkupColor(displayName: "White", color: Color.white)
    ]
    
    
    /// This variable holds the screenshot of the first view when the feedback bubble was pressed.
    @Published var screenshot: UIImage = Model.getScreenShot()
    /// This variable holds the screenshot of the view after the user draws and saves markups on the first view when the feedback bubble was clicked.
    @Published var screenshotWithMarkup: UIImage = Model.getScreenShot()
    /// This variable holds all the drawings the user draws in the Markup view.
    @Published var markupDrawings: [Drawing] = [Drawing]()
    /// This boolean variable is used to check if the user is submitting feedback with or without logging in.
    @Published var continueWithoutLogin: Bool = false
}
