//
//  EditScreenshotView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 03.01.20.
//

import SwiftUI

/// This View enables the user to Markup the first view of the application, when the feedback bubble was pressed.
struct EditScreenshotView: View {
    /// The instance of the Observable Object class named Model,  to share model data anywhere it’s needed.
    @EnvironmentObject var model: Model
    /// Environment variable for presentationMode to dismiss the View.
    @Environment(\.presentationMode) var presentationMode
    /// The State variable holds the current Drawing being drawn on this View.
    @State var currentDrawing: Drawing?
    /// This State variable holds all the drawings and is initialised with the existing strokes when the View appears.
    @State var allDrawings: [Drawing] = []
    /// The frame data of the markup image in the cuurent View.
    @State var rect: CGRect = .zero
    /// The initial color for markup when the View appears.
    @State var color: Color = .primary
    /// This attribute is updated when the user wants to change the Markup Color.
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
                    ForEach(self.allDrawings) { drawing in
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
    
    /// The color picker, undo and clear actions for the Markup View.
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
                    if self.allDrawings.count > 0 {
                        self.allDrawings.removeLast()
                    }
            }
            Image(systemName: "xmark")
                .imageScale(.large)
                .onTapGesture {
                    self.allDrawings = [Drawing]()
            }
        }.frame(height: 32)
    }
    
    /// This view records the strokes and gestures of the user on the current View.
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
                self.currentDrawing.map({ self.allDrawings.append($0) })
                self.currentDrawing = nil
            }
    }
    
    /// The cancel button displayed on the left top corner of the View.
    private var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    /// The save button displayed on the top right corner of the View.
    private var saveButton: some View {
        Button(action: save) {
            Text("Save").bold()
        }
    }
    
    /// The action to be perfomed when the save button is pressed.
    private func save() {
        self.model.markupDrawings = allDrawings
        self.model.screenshotWithMarkup = UIApplication.shared.windows.first?.asImage(rect: rect) ?? UIImage()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /// The action to be performed when the cancel button is pressed.
    private func cancel() {
        if colorPickerShown {
            colorPickerShown = false
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    /// This function is called when the View appears, to initialise the allDrawings State variable.
    private func setupCurrentDrawings() {
        self.allDrawings = self.model.markupDrawings
    }
}
