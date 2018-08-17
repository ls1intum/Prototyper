//
//  AppDelegate.swift
//  Prototyper Example
//
//  Created by Paul Schmiedmayer on 6/6/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit
import Prototyper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PrototyperController.showFeedbackButton = true
        
        return true
    }
}

