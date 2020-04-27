//
//  ColorPickerView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import SwiftUI


// MARK: ColorPickerView
/// This View is basically a List of all the colors available and displays them as a list of ColorPickerCell's.
struct ColorPickerView: View {
    /// The color attribute is binded to the calling View and the markup color is updated.
    @Binding var color: Color
    /// This attribute is updated once the new color is chosen which in turn dismisses the View.
    @Binding var colorPickerShown: Bool
    
    
    var body: some View {
        List(MarkupColor.defaultColors) { color in
            ColorPickerCell(colorInfo: color).onTapGesture {
                self.color = color.color
                self.colorPickerShown = false
            }
        }.navigationBarTitle("Color Picker")
    }
}
