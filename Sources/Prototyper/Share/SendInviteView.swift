//
//  SendInviteView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

/// This View appears when the logged in user sends an invite.
struct SendInviteView: View {
    /// The instance of the Observable Object class named Model,  to share model data anywhere it’s needed.
    @EnvironmentObject var model: Model
    /// This State variable tells the Activity indicator to Animate or not.
    @State private var shouldAnimate = true
    /// This State variable is updated to true when sending invite fails.
    @State private var showingAlert = false
    /// Once the invite is sent the View is dismissed by updating this variable.
    @Binding var showSendInviteView: Bool
    /// The variable holds the email id to whom the invite needs to be sent to and the invite text, which is given by the ShareView.
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
    
    /// This function is called instantly when the View appears
    private func sendShareRequest() {
        guard var shareRequest = shareRequest else {
            return
        }
        
        shareRequest.creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        
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
