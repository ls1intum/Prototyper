//
//  ActivityIndicator.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import Foundation
import SwiftUI


// MARK: ActivityIndicator
struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
