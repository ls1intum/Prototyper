//
//  DrawingBoard.swift
//  
//
//  Created by Paul Schmiedmayer on 9/21/20.
//

import SwiftUI
import PencilKit


// MARK: DrawingBoard
///Thjs view is a paintable overlay for the screenshot
struct DrawingBoard: UIViewRepresentable {
    @EnvironmentObject var state: PrototyperState
    
    ///Bindings for the initialization
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    let eraser = PKEraserTool(.vector)
    
    
    var ink: PKInkingTool {
        PKInkingTool(type, color: UIColor(color))
    }
    
    
    ///Set up the canvas
    func makeUIView(context: Context) -> PKCanvasView {
        if let drawings = state.markupDrawings {
            canvas.drawing = drawings
        }
        
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink: eraser
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.overrideUserInterfaceStyle = .light
        
        return canvas
    }
    
    ///Updates the tool
    func updateUIView (_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw ? ink: eraser
    }
}
