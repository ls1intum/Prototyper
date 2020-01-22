//
//  Model.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import Foundation
import SwiftUI

class Model: ObservableObject {
    @Published var screenshot: UIImage = Model.getScreenShot()
    @Published var continueWithoutLogin: Bool = false
    
    static func getScreenShot() -> UIImage {
        PrototyperController.isFeedbackButtonHidden = true
        let screenshot =  UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.screenshot ?? UIImage()
        PrototyperController.isFeedbackButtonHidden = false
        return screenshot
    }
    
    static let markupColors: [MarkupColor] = [
        MarkupColor(displayName: "Black", color: Color.black),
        MarkupColor(displayName: "Red", color: Color.red),
        MarkupColor(displayName: "Blue", color: Color.blue),
        MarkupColor(displayName: "Yellow", color: Color.yellow),
        MarkupColor(displayName: "Green", color: Color.green),
        MarkupColor(displayName: "White", color: Color.white)
    ]
}
