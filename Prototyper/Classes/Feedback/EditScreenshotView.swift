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
    @Environment(\.colorScheme) var colorScheme
    @State var currentDrawing: Drawing = Drawing()
    @State var drawings: [Drawing] = [Drawing]()
    @State var rect: CGRect = .zero
    @State var color: Color = Color.black
    @State var colorPickerShown: Bool = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Button("Pick color") {
                    self.colorPickerShown.toggle()
                }
                Button("Undo") {
                    if self.drawings.count > 0 {
                        self.drawings.removeLast()
                    }
                }
                Button("Clear") {
                    self.drawings = [Drawing]()
                }
            }.offset(x: -5)
            GeometryReader { geometry in
                Path { path in
                    for drawing in self.drawings {
                        self.add(drawing: drawing, toPath: &path)
                    }
                    self.add(drawing: self.currentDrawing, toPath: &path)
                }
                .stroke(self.color, lineWidth: 7)
                .background(Image(uiImage: self.model.screenshot)
                .resizable()
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
                
            }.background(RectGetter(rect: $rect))
                .navigationBarTitle("Markup View")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }.sheet(isPresented: $colorPickerShown) {
            NavigationView {
                ColorPickerView(color: self.$color, colorPickerShown: self.$colorPickerShown)
                .navigationBarTitle("Pick Color")
            }.environmentObject(self.model)
        }.onAppear(perform: setColor)
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
    
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    private var saveButton : some View {
        Button(action: save) {
            Text("Save").bold()
        }
    }
    
    private func setColor() {
        color = colorScheme == .light ? Color.black : Color.white
    }
    
    private func save() {
        self.drawings = [Drawing]()
        self.model.screenshot = UIApplication.shared.windows.first?.asImage(rect: rect) ?? UIImage()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func cancel() {
        self.drawings = [Drawing]()
        self.presentationMode.wrappedValue.dismiss()
    }
}

