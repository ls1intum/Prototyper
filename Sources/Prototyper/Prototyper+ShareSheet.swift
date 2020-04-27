//
//  Prototyper+ShareSheet.swift
//  
//
//  Created by Paul Schmiedmayer on 4/24/20.
//

import Foundation
import UIKit
import SwiftUI


extension Prototyper {
    ///Presents the ShareView as a UIHostingController.
    public static func showShareApp() {
        let shareView: some View = ShareView()
            .environmentObject(currentState)
            .environmentObject(apiHandler)
        
        let instantiatedViewController = UIHostingController(rootView: shareView)
        instantiatedViewController.isModalInPresentation = true
        
        currentState.feedbackButtonIsHidden = true
        
        topViewController?.present(instantiatedViewController,
                                   animated: true,
                                   completion: nil)
    }
}
