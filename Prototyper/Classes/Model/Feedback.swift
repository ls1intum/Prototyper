//
//  Feedback.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation

struct Feedback {
    let description: String
    let screenshot: UIImage?
    let creatorName: String?
}

extension Feedback: CustomStringConvertible {}

