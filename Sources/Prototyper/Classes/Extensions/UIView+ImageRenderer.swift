//
//  UIView+ImageRenderer.swift
//  Prototyper
//
//  Created by Raymond Pinto on 21.01.20.
//

import Foundation

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
