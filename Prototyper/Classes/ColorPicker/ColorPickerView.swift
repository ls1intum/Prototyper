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
    
    var body: some View {
        List {
            ForEach(Model.markupColors) { color in
                ColorPickerCell(colorInfo: color).onTapGesture {
                    self.color = color.color
                    self.colorPickerShown = false
                }
            }
        }.padding()
        .navigationBarTitle("Color Picker")
    }
}
