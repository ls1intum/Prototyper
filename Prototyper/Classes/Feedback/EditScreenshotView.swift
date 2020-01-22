//
//  EditScreenshotView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 03.01.20.
//

import SwiftUI

struct EditScreenshotView: View {
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    @State var currentDrawing: Drawing?
    @State var currentDrawings: [Drawing] = [Drawing]()
    @State var rect: CGRect = .zero
    @State var color: Color = .primary
    @State var colorPickerShown: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 16)
            ZStack(alignment: .center) {
                Image(uiImage: self.model.screenshot)
                    .resizable()
                    .scaledToFit()
                    .background(RectGetter(rect: self.$rect))
                    .shadow(color: Color.primary.opacity(0.2), radius: 5.0)
                Group {
                    ForEach(self.currentDrawings) { drawing in
                        drawing.path
                    }
                    currentDrawing?.path
                }.offset(y: -self.rect.origin.y)

            }.gesture(dragGesture)
            Spacer(minLength: 16)
            actions
        }.onAppear(perform: setupCurrentDrawings)
            .navigationBarTitle("Markup")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .sheet(isPresented: $colorPickerShown) {
                NavigationView {
                    ColorPickerView(color: self.$color, colorPickerShown: self.$colorPickerShown)
                        .navigationBarItems(leading: self.cancelButton)
                }.environmentObject(self.model)
            }
    }
    
    var actions: some View {
        HStack (alignment: .center, spacing: 30) {
            Image(systemName: "eyedropper.halffull")
                .imageScale(.large)
                .onTapGesture {
                    self.colorPickerShown.toggle()
            }
            Image(systemName: "arrow.uturn.left")
                .imageScale(.large)
                .onTapGesture {
                    if self.currentDrawings.count > 0 {
                        self.currentDrawings.removeLast()
                    }
            }
            Image(systemName: "xmark")
                .imageScale(.large)
                .onTapGesture {
                    self.currentDrawings = [Drawing]()
            }
        }.frame(height: 32)
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { value in
                if self.rect.contains(value.location) {
                    if self.currentDrawing == nil {
                        self.currentDrawing = Drawing(color: self.color)
                    }
                    self.currentDrawing?.points.append(value.location)
                }
            }
            .onEnded { _ in
                self.currentDrawing.map({ self.currentDrawings.append($0) })
                self.currentDrawing = nil
            }
    }
    
    private var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View {
        Button(action: save) {
            Text("Save").bold()
        }
    }
    
    private func save() {
        self.model.markupDrawings.removeAll()
        self.currentDrawings.forEach({ self.model.markupDrawings.append($0) })
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
    
    private func setupCurrentDrawings() {
        self.model.markupDrawings.forEach({ self.currentDrawings.append($0) })
    }
}
