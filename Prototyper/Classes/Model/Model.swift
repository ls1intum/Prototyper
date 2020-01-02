//
//  Model.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import Foundation

class Model: ObservableObject {
    @Published var showLoginView: Bool = false
    @Published var showSendInviteView: Bool = false
    @Published var screenshot: UIImage = Model.getScreenShot()
    
    static func getScreenShot() -> UIImage {
        PrototyperController.isFeedbackButtonHidden = true
        let screenshot =  UIApplication.shared.keyWindow?.screenshot ?? UIImage()
        PrototyperController.isFeedbackButtonHidden = false
        return screenshot
    }
}
