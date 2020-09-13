//
//  Prototyper_ExampleApp.swift
//  Prototyper Example
//
//  Created by Paul Schmiedmayer on 8/24/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import Prototyper


@main
struct PrototyperExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .prototyper(PrototyperSettings.default)
        }
    }
}
