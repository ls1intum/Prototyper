//
//  EditScreenshotView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 03.01.20.
//

import SwiftUI

struct Drawing {
    var points: [CGPoint] = []
}

struct EditScreenshotView: View {
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    @State var currentDrawing: Drawing = Drawing()
    @State var drawings: [Drawing] = [Drawing]()
    @State var rect: CGRect = .zero
    
    var body: some View {
            GeometryReader { geometry in
                Path { path in
                    for drawing in self.drawings {
                        self.add(drawing: drawing, toPath: &path)
                    }
                    self.add(drawing: self.currentDrawing, toPath: &path)
                }
                .stroke(Color.black, lineWidth: 7)
                .background(Image(uiImage: self.model.screenshot)
                    .resizable()
                    .border(Color.black)
                .scaledToFit())
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged({ (value) in
                            let currentPoint = value.location
                            if currentPoint.y >= 0
                                && currentPoint.y < geometry.size.height {
                                self.currentDrawing.points.append(currentPoint)
                            }
                        })
                        .onEnded({ (value) in
                            self.drawings.append(self.currentDrawing)
                            self.currentDrawing = Drawing()
                        })
                )
                
            }
    .background(RectGetter(rect: $rect))
            .frame(maxHeight: .infinity)
        .navigationBarTitle("Markup View")
        .navigationBarItems(trailing: saveButton)
    }
    
    private func add(drawing: Drawing, toPath path: inout Path) {
        let points = drawing.points
        if points.count > 1 {
            for i in 0..<points.count-1 {
                let current = points[i]
                let next = points[i+1]
                path.move(to: current)
                path.addLine(to: next)
            }
        }
    }
    
    private var saveButton : some View {
        Button(action: save) {
            Text("Save").bold()
        }
    }
    
    private func save() {
        self.drawings = [Drawing]()
        self.model.screenshot = UIApplication.shared.windows.first?.asImage(rect: rect) ?? UIImage()
        self.presentationMode.wrappedValue.dismiss()
    }
}
