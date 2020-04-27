//
//  MarkupHelper.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import SwiftUI


// MARK: RectGetter
struct RectGetter: View {
    @Binding var rect: CGRect

    
    var body: some View {
        GeometryReader { reader in
            Rectangle().fill(Color.clear).onAppear {
                self.rect = reader.frame(in: .global)
            }
        }
    }
}
