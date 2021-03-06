//
//  Prototyper+FeedbackSheet.swift
//  
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import Foundation
import UIKit
import SwiftUI


extension Prototyper {
    /// Presents the FeedbackView as a UIHostingController
    public static func showFeedbackView() {
        takeScreenshot()
        
        let shareView: some View = FeedbackView()
            .environmentObject(currentState)
        
        let instantiatedViewController = UIHostingController(rootView: shareView)
        instantiatedViewController.isModalInPresentation = true
        instantiatedViewController.isModalInPresentation = true
        
        currentState.feedbackButtonIsHidden = true
        
        topViewController?.present(instantiatedViewController, animated: true, completion: nil)
    }
}
