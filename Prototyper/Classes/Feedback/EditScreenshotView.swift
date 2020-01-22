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
    @State var currentMarkupDrawing: Drawing = Drawing()
    @State var rect: CGRect = .zero
    @State var color: Color = Color.primary
    @State var colorPickerShown: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                Path { path in
                    for markupDrawing in self.model.markupDrawings {
                        self.add(drawing: markupDrawing, toPath: &path)
                    }
                    self.add(drawing: self.currentMarkupDrawing, toPath: &path)
                }.offsetBy(dx: -15, dy: -self.rect.origin.y)
                .stroke(self.color, lineWidth: 5)
                .background(
                    Image(uiImage: self.model.screenshot)
                        .resizable()
                        .scaledToFit()
                        .background(RectGetter(rect: self.$rect))
                        .shadow(color: Color.primary.opacity(0.2), radius: 5.0))
                .gesture(
                    DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                        .onChanged({ (value) in
                            if self.rect.contains(value.location) {
                                self.currentMarkupDrawing.points.append(value.location)
                            }
                        })
                        .onEnded({ (value) in
                            self.model.markupDrawings.append(self.currentMarkupDrawing)
                            self.currentMarkupDrawing = Drawing()
                        })
                )
            }.padding()
            HStack (alignment: .center, spacing: 30) {
                Image(systemName: "eyedropper.halffull")
                    .imageScale(.large)
                    .onTapGesture {
                        self.colorPickerShown.toggle()
                    }
                Image(systemName: "arrow.uturn.left")
                    .imageScale(.large)
                    .onTapGesture {
                        if self.model.markupDrawings.count > 0 {
                            self.model.markupDrawings.removeLast()
                        }
                    }
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .onTapGesture {
                        self.model.markupDrawings = [Drawing]()
                    }
            }.frame(height: 32)
        }
        .navigationBarTitle("Markup")
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
        .sheet(isPresented: $colorPickerShown) {
            NavigationView {
                ColorPickerView(color: self.$color, colorPickerShown: self.$colorPickerShown)
                    .navigationBarItems(leading: self.cancelButton)
            }.environmentObject(self.model)
        }
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
    
    private func save() {
        self.model.screenshotWithMarkup = UIApplication.shared.windows.first?.asImage(rect: rect) ?? UIImage()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func cancel() {
        if colorPickerShown {
            colorPickerShown = false
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

