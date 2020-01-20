//
//  MarkupWithPencilKitView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 20.01.20.
//

import SwiftUI

struct MarkupWithPencilKitView: View {
    @EnvironmentObject var model: Model
    @State var drawing: UIImage
    
    var body: some View {
        PKCanvasRepresentation(drawing: $drawing)
    }
}
