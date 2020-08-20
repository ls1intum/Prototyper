//
//  SwiftUIView.swift
//  
//
//  Created by Simon Borowski on 12.08.20.
//

import SwiftUI
import PencilKit

struct EditScreenshotPK: View  {
    @State private var canvasView = PKCanvasView()
    var body: some View {
        VStack {
            MyCanvas(canvasView: $canvasView)
    }
}
}

struct EditScreenshotPK_Previews: PreviewProvider {
    static var previews: some View {
        EditScreenshotPK()
    }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
}
