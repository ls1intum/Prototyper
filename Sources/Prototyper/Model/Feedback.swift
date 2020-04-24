//
//  Feedback.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import UIKit


// MARK: Drawing
/// This struct holds the data associated with the feedback.
struct Feedback {
    /// The description of the feedback.
    let description: String
    /// The screenshot image to be sent as part of the feedback.
    let screenshot: UIImage?
    /// The name of the user sending the feedback.
    var creatorName: String?
}


// MARK: Feedback + CustomStringConvertible
extension Feedback: CustomStringConvertible { }
