//
//  MarkupHelper.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.01.20.
//

import Foundation
import SwiftUI

struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { reader in
            self.createView(reader: reader)
        }
    }

    func createView(reader: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = reader.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
