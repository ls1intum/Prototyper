//
//  UIImage+OverlapImages.swift
//  Prototyper
//
//  Created by Raymond Pinto on 24.01.20.
//

import Foundation
import UIKit


// MARK: UIView + Overlap two UIImages
extension UIImage {
    /// Used to overlap two images, one on top of another.
    static func overlapImages(topImage: UIImage, bottomImage: UIImage) -> UIImage {
        let bottomImageContainer = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        let topImageContainer = CGRect(x: (bottomImage.size.width / 2.0) - (topImage.size.width / 2.0),
                                       y: (bottomImage.size.height / 2.0) - (topImage.size.height / 2.0),
                                       width: topImage.size.width,
                                       height: topImage.size.height)
        
        
        UIGraphicsBeginImageContextWithOptions(bottomImage.size, false, 2.0)
        bottomImage.draw(in: bottomImageContainer)
        topImage.draw(in: topImageContainer)
        return UIGraphicsGetImageFromCurrentImageContext() ?? bottomImage
    }
}
