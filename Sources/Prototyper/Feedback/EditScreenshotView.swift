//
//  EditScreenshotView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 03.01.20.
//
import SwiftUI
import PencilKit

// MARK: EditScreenshotView
/// This View enables the user to Markup the first view of the application, when the feedback bubble was pressed.
struct EditScreenshotView: View {
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    /// Environment variable for presentationMode to dismiss the View.
    @Environment(\.presentationMode) var presentationMode
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    
    
    var inkTypeImage: String {
        switch type {
        case .pencil:
            return "pencil.tip"
        case .pen:
            return "highlighter"
        case .marker:
            return "pencil"
        default:
            return "pencil.tip"
        }
    }
    
    ///Changes the pencil image whether you are drawing or want to erase something
    var pencilImage: String {
        isDraw ?  "pencil.slash" : "pencil.and.outline"
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 16)
            ZStack(alignment: .center) {
                Image(uiImage: state.getScreenshot())
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color.primary.opacity(0.2), radius: 5.0)
                    .overlay(DrawingBoard(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color))
            }
            Spacer(minLength: 16)
            actions
        }
        .navigationBarTitle("Markup")
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
    }
    
    ///View for all drawing related actions
    var actions: some View {
        HStack(alignment: .center, spacing: 30) {
            Image(systemName: pencilImage)
                .imageScale(.large)
                .onTapGesture {
                    isDraw.toggle()
                }
            Image(systemName: inkTypeImage)
                .imageScale(.large)
                .onTapGesture {
                    changeInkType()
                }
            ColorPicker(selection: $color) {
                Text("")
            }
            .frame(width: 30)
            .padding(.trailing, 8)
        }
        .frame(height: 32)
    }
    
    /// The cancel button displayed on the left top corner of the View.
    private var cancelButton: some View {
        Button(action: cancle) {
            Text("Cancel")
        }
    }
    
    /// The save button displayed on the top right corner of the View.
    private var saveButton: some View {
        Button(action: saveDrawing) {
            Text("Save").bold()
        }
    }
    
    
    ///Adds the drawings to the screenshot
    func saveDrawing() {
        state.markupDrawings = canvas.drawing
        let drawingImage = canvas.drawing.image(from: canvas.bounds, scale: 1)
        state.screenshotWithMarkup = combineImage(top: drawingImage, bottom: state.getScreenshot())
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    ///Stores the current drawjngs and closes the view
    func cancle() {
        //If the current drawings should be deleted, just comment out this line
        state.markupDrawings = canvas.drawing
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    ///Combines to images to one
    func combineImage(top: UIImage, bottom: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(top.size)
        
        let areaSize = CGRect(x: 0, y: 0, width: top.size.width, height: top.size.height)
        bottom.draw(in: areaSize)
        top.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        
        // swiftlint:disable:next force_unwrapping
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    ///Changes the ink / tool
    func changeInkType() {
        isDraw = true
        switch type {
        case .pencil:
            type = .pen
        case .pen:
            type = .marker
        case .marker:
            type = .pencil
        default:
            type = .pen
        }
    }
}
