//
//  SceneDelegate.swift
//  Prototyper Example
//
//  Created by Paul Schmiedmayer on 10/29/19.
//  Copyright © 2019 TUM LS1. All rights reserved.
//

import UIKit
import SwiftUI
import Prototyper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView(prototypeName: "Prototype")

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            
            PrototyperController.showFeedbackButton = true
            
            window.makeKeyAndVisible()
        }
    }
}
