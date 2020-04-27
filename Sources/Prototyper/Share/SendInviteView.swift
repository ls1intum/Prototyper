//
//  SendInviteView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI


// MARK: SendInviteView
/// This View appears when the logged in user sends an invite.
struct SendInviteView: View {
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    /// <#Description#>
    @EnvironmentObject var apiHandler: APIHandler
    
    /// Once the invite is sent the View is dismissed by updating this variable.
    @Binding var showSendInviteView: Bool
    /// The variable holds the email id to whom the invite needs to be sent to and the invite text, which is given by the ShareView.
    @Binding var shareRequest: ShareRequest?
    
    /// This State variable tells the Activity indicator to Animate or not.
    @State private var shouldAnimate = true
    /// This State variable is updated to true when sending invite fails.
    @State private var showingAlert = false
    
    
    var body: some View {
            VStack {
                ActivityIndicator(isAnimating: self.$shouldAnimate)
                    .onAppear { self.sendShareRequest() }
                Text("Sending the invitation to Prototyper")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"),
                      message: Text("Could not send feedback to server."),
                      dismissButton: .default(Text("OK")) {
                    self.showSendInviteView = false
                })
            }
            .navigationBarTitle("Sending Invitation")
    }
    
    
    /// Sends the invite to the email mentioned in the ShareRequest object and on failure shows an alert.
    private func sendShareRequest() {
        guard var shareRequest = shareRequest else {
            return
        }
        
        shareRequest.creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        
        apiHandler.send(shareRequest: shareRequest,
                        success: {
            print("Successfully sent share request to server")
            Prototyper.dismissView()
            Prototyper.currentState.feedbackButtonIsHidden = !Prototyper.settings.showFeedbackButton
        }, failure: { _ in
            self.shouldAnimate = false
            self.showingAlert = true
        })
    }
}
