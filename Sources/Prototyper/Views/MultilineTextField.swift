//
//  MultilineTextField.swift
//  Prototyper
//
//  Created by Raymond Pinto on 04.12.19.
//

import Foundation
import SwiftUI


// MARK: MultilineTextView
struct MultilineTextView: UIViewRepresentable {
    // MARK: Coordinator
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextView

        init(_ uiTextView: MultilineTextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholderText
                textView.textColor = .placeholderText
            }
        }
    }
    
    
    @Binding var text: String
    
    var placeholderText: String

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let myTextView = UITextView()
        myTextView.textContainer.lineFragmentPadding = 0
        myTextView.textContainerInset = .zero
        myTextView.font = UIFont.systemFont(ofSize: 17)
        
        myTextView.text = placeholderText
        myTextView.textColor = .placeholderText
        
        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.delegate = context.coordinator
        if !text.isEmpty {
            uiView.text = text
            uiView.textColor = .label
        }
    }
    
    func frame(numLines: CGFloat) -> some View {
        let height = UIFont.systemFont(ofSize: 17).lineHeight * numLines
        return self.frame(height: height)
    }
}
