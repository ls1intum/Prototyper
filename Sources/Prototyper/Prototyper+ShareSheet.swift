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
        let instantiatedViewController = UIHostingController(rootView: ShareView().environmentObject(Model()))
        instantiatedViewController.isModalInPresentation = true
        
        currentState.feedbackButtonIsHidden = true
        
        topViewController?.present(instantiatedViewController,
                                   animated: true,
                                   completion: nil)
    }
}
