//
//  PKCanvas.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import PencilKit
import SwiftUI

struct PKCanvasRepresentation : UIViewRepresentable {
    @Binding var drawing: UIImage
    
    func makeCoordinator() -> PKCoordinator {
        PKCoordinator(self)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.tool = PKInkingTool(.pen, color: UIColor.black, width: 10)
        canvas.isOpaque = false
        canvas.backgroundColor = UIColor(patternImage: drawing)
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.delegate = context.coordinator
    }
}

class PKCoordinator: NSObject, PKCanvasViewDelegate {
    var parent: PKCanvasRepresentation

    init(_ parent: PKCanvasRepresentation) {
        self.parent = parent
    }
}
