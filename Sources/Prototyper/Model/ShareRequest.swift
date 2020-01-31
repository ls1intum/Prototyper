//
//  ShareRequest.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation

/// An instance of this struct holds the details of the user to whom the app is to be shared.
struct ShareRequest {
    let email: String
    let content: String
    let creatorName: String?
}
