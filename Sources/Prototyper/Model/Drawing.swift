//
//  Drawing.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 1/22/20.
//

import Foundation
import SwiftUI

/// An instance of this this struct is a stroke drawn on the markup view.
struct Drawing: Hashable, Identifiable {
    /// The color of the stroke drawn
    var color: Color
    /// The array of points associated with the stroke
    var points: [CGPoint] = []
    /// The Hashable id of the stroke
    var id: Int {
        hashValue
    }
    /// Draws the path of the stroke using the array of points.
    var path: some View {
        var path = Path()
        points.first.map { path.move(to: $0) }
        path.addLines(points)
        return path.stroke(color, lineWidth: 2.5)
    }
    
    /// Hashes the essential components of this value by feeding them into the given hasher.
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.color)
        for point in self.points {
            hasher.combine(point.x)
            hasher.combine(point.y)
        }
    }
}
