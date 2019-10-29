//
//  ContentView.swift
//  Prototyper Example
//
//  Created by Paul Schmiedmayer on 10/29/19.
//  Copyright © 2019 TUM LS1. All rights reserved.
//

import SwiftUI
import Prototype

struct ContentView: View {
    @State var prototypeName: String
    
    var body: some View {
        PrototypeContainer(prototypeName: $prototypeName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(prototypeName: "Prototype")
    }
}
