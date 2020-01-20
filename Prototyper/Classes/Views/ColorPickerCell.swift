//
//  ColorPickerCell.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import SwiftUI

struct ColorPickerCell: View {
    let colorInfo: ColorModel
    
    var body: some View {
        HStack {
            Circle()
                .fill(colorInfo.color)
                .frame(width: 40, height: 40)
                .padding(.all)
            Text(colorInfo.displayName)
        }
    }
}
