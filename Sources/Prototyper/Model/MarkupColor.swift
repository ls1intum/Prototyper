//
//  MarkupColor.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import SwiftUI

/// An instance of this struct holds the name of a color and the color itself.
struct MarkupColor: Identifiable {
    /// The name of the color
    let displayName: String
    /// The color itself
    let color: Color
    /// The id associated with the color
    var id: String {
        return displayName
    }
}
