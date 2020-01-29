//
//  Drawing.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 1/22/20.
//

import Foundation
import SwiftUI

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

struct Drawing: Hashable, Identifiable {
    var color: Color
    var points: [CGPoint] = []
    
    var id: Int {
        return hashValue
    }
    
    var path: some View {
        var path = Path()
        points.first.map { path.move(to: $0) }
        path.addLines(points)
        return path.stroke(color, lineWidth: 2.5)
    }
}
