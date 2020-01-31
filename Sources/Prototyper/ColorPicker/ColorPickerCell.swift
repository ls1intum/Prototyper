//
//  ColorPickerCell.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import SwiftUI

/// This View displays the color and the name on one cell in a list.
struct ColorPickerCell: View {
    /// This attribute picks up the color info passed by the ColorPickerView
    let colorInfo: MarkupColor
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorInfo.color)
                .frame(width: 40, height: 40)
                .shadow(radius: 4.0)
                .padding()
            Text(colorInfo.displayName)
        }
    }
}
