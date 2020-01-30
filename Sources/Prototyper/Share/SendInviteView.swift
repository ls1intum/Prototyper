//
//  SendInviteView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

struct SendInviteView: View {
    @EnvironmentObject var model: Model
    @State private var shouldAnimate = true
    @State private var showingAlert = false
    @Binding var showSendInviteView: Bool
    @Binding var shareRequest: ShareRequest?
    
    var body: some View {
            VStack {
                ActivityIndicator(isAnimating: self.$shouldAnimate)
                    .onAppear { self.sendShareRequest() }
                Text("Sending the invitation to Prototyper")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Could not send feedback to server."), dismissButton: .default(Text("OK"), action: {
                    self.showSendInviteView = false
                }))
            }.navigationBarTitle("Sending Invitation")
    }
    
    private func sendShareRequest() {
        guard let shareRequest = shareRequest else {
            return
        }
        
        if (shareRequest.creatorName == nil) {
            UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        APIHandler.send(shareRequest: shareRequest,
                        success: {
            print("Successfully sent share request to server")
            PrototyperController.isFeedbackButtonHidden = false
            PrototyperController.dismissView()
        }, failure: { _ in
            self.shouldAnimate = false
            self.showingAlert = true
        })
    }
}
