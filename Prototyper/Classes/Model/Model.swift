//
//  Model.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import Foundation

class Model: ObservableObject {
    @Published var viewStatus: PrototyperController.Constants.ViewStatus = .shareView
}
