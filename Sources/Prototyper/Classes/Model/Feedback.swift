//
//  Feedback.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

struct Feedback {
    let description: String
    let screenshot: UIImage?
    let creatorName: String?
}

extension Feedback: CustomStringConvertible {}
