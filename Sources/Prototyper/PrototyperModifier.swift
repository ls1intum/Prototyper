//
//  File.swift
//  
//
//  Created by Simon Borowski on 18.08.20.
//

import Foundation
import SwiftUI

struct ProtoytperModifier: ViewModifier {
    
    var settings: PrototyperSettings
    
    init(_ settings: PrototyperSettings) {
        self.settings = settings
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            Prototyper.configure(settings)
        }
    }
}

extension View {
    
    public func prototyper(_ settings: PrototyperSettings) -> some View {
        let prototyperModifier = ProtoytperModifier(settings)
        return self.modifier(prototyperModifier)
    }
}

