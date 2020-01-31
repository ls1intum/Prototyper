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
    /// The email id of the user to whom the app is to be shared
    let email: String
    /// The invite text to be sent
    let content: String
    /// The user's name sending the invite, if not logged in.
    var creatorName: String?
}
