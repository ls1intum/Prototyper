//
//  MarkupColor.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import SwiftUI


// MARK: MarkupColor
/// An instance of this struct holds the name of a color and the color itself.
struct MarkupColor: Identifiable {
    /// The name of the color
    let displayName: String
    /// The color itself
    let color: Color
    
    
    /// The id associated with the color
    var id: String {
        displayName
    }
}


extension MarkupColor {
    /// The markup colors provided to draw on the EditScreenshotView
    static let defaultColors: [MarkupColor] = [
        MarkupColor(displayName: "Black", color: Color.black),
        MarkupColor(displayName: "Red", color: Color.red),
        MarkupColor(displayName: "Blue", color: Color.blue),
        MarkupColor(displayName: "Yellow", color: Color.yellow),
        MarkupColor(displayName: "Green", color: Color.green),
        MarkupColor(displayName: "White", color: Color.white)
    ]
}
