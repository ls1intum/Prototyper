//
//  PrototyperError.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation


// MARK: PrototyperError
/// The errors associated with logging in into Prototyper
enum PrototyperError: Error {
    case APIURLError
    case dataParseError
    case dataEncodeError
}
