//
//  MarkupColor.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import SwiftUI

struct MarkupColor: Identifiable {
    let displayName: String
    let color: Color
    
    var id: String {
        return displayName
    }
}
