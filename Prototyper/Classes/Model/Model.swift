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
    
    static func getScreenShot() -> UIImage {
        PrototyperController.isFeedbackButtonHidden = true
        let screenshot =  UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.screenshot ?? UIImage()
        PrototyperController.isFeedbackButtonHidden = false
        return screenshot
    }
    
    static func markupColors() -> [ColorModel] {
        return [ColorModel(id: 1, displayName: "Black", color: Color.black),
                ColorModel(id: 2, displayName: "Red", color: Color.red),
                ColorModel(id: 3, displayName: "Blue", color: Color.blue),
                ColorModel(id: 4, displayName: "Yellow", color: Color.yellow),
            ColorModel(id: 5, displayName: "Green", color: Color.green),
            ColorModel(id: 6, displayName: "White", color: Color.white)]
    }
}
