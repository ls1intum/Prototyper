//
//  ColorPickerView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import SwiftUI

struct ColorPickerView: View {
    @EnvironmentObject var model: Model
    @Binding var color: Color
    @Binding var colorPickerShown: Bool
    
    private let colors = Model.markupColors()
    
    var body: some View {
        List {
            ForEach(colors) { color in
                ColorPickerCell(colorInfo: color).onTapGesture {
                    self.color = color.color
                    self.colorPickerShown = false
                }
            }
        }
    }
}
