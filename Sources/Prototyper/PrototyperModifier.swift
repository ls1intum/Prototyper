//
//  File.swift
//  
//
//  Created by Simon Borowski on 18.08.20.
//

import Foundation
import SwiftUI


///PrototyperModifier is a view modifier that attaches the feedback bubble to a view
struct ProtoytperModifier: ViewModifier {
    
    var settings: PrototyperSettings
    
    init(_ settings: PrototyperSettings) {
        self.settings = settings
    }
    
    /// Function that initializes prototyper and returns an unchanged view
    /// - Parameter content: Current View
    func body(content: Content) -> some View {
        content.onAppear {
            Prototyper.configure(settings)
        }
    }
}

extension View {
    
    /// Function to wrap ´modifier(prototyperModifier)´
    public func prototyper(_ settings: PrototyperSettings) -> some View {
        let prototyperModifier = ProtoytperModifier(settings)
        return self.modifier(prototyperModifier)
    }
}

