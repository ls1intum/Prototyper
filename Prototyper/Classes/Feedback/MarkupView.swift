//
//  MarkupView.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class Stroke {
    var samples = [StrokeSample]()
    var lineWidth = CGFloat(2.5)
    var color = #colorLiteral(red: 0, green: 0.4877254367, blue: 1, alpha: 1)
    
    var bezierPath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        guard let startPoint = samples.first?.location else {
            return path
        }
        
        path.move(to: startPoint)
        samples.dropFirst().forEach({
            path.addLine(to: $0.location)
        })
        
        return path
    }
    
    func add(sample: StrokeSample) {
        samples.append(sample)
    }
}

struct StrokeSample {
    let location: CGPoint
    let coalescedSample: Bool
    
    init(point: CGPoint, coalesced : Bool = false) {
        location = point
        coalescedSample = coalesced
    }
}

class StrokeCollection {
    var strokes = [Stroke]()
    var activeStroke: Stroke? = nil
    
    func acceptActiveStroke() {
        if let stroke = activeStroke {
            strokes.append(stroke)
            activeStroke = nil
        }
    }
}

class MarkupView: UIView {
    var strokeCollection = StrokeCollection() {
        didSet {
            if oldValue !== strokeCollection {
                setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        strokeCollection.strokes.forEach({
            $0.color.setStroke()
            $0.bezierPath.stroke()
        })
        
        strokeCollection.activeStroke?.color.setStroke()
        strokeCollection.activeStroke?.bezierPath.stroke()
    }
    
    // MARK: Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newStroke = Stroke()
        strokeCollection.activeStroke = newStroke
        
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let coalesced = event?.coalescedTouches(for: touches.first!) {
            addSamples(for: coalesced)
        }
        
        strokeCollection.acceptActiveStroke()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        strokeCollection.activeStroke = nil
    }
    
    // MARK: Image Handling
    
    func drawContent(onImage image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size,
                                               false,
                                               UIScreen.main.scale)
        image.draw(at: .zero)
        
        let context = UIGraphicsGetCurrentContext()!
        
        let scaleFactor = image.size.height / self.frame.size.height
        context.translateBy(x: (image.size.width - self.frame.size.width * scaleFactor) / 2, y: 0)
        context.scaleBy(x: scaleFactor, y: scaleFactor)
        
        draw(.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: Helper
    
    private func addSamples(for touches: [UITouch]) {
        if let stroke = strokeCollection.activeStroke {
            for touch in touches {
                if touch == touches.last {
                    let sample = StrokeSample(point: touch.preciseLocation(in: self))
                    stroke.add(sample: sample)
                } else {
                    let sample = StrokeSample(point: touch.preciseLocation(in: self),
                                              coalesced: true)
                    stroke.add(sample: sample)
                }
            }
            self.setNeedsDisplay()
        }
    }
}
