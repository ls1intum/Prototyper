//
//  SendFeedbackView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 02.01.20.
//

import SwiftUI


// MARK: SendFeedbackView
/// This View appears when the logged in user sends feedback.
struct SendFeedbackView: View {
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    /// <#Description#>
    @EnvironmentObject var apiHandler: APIHandler
    
    /// Once the feedback is sent the View is dismissed by updating this variable.
    @Binding var showSendFeedbackView: Bool
    /// The variable holds the image and the feedback text to be sent, which is given by the FeedbackView.
    @Binding var feedback: Feedback?
    
    /// This State variable tells the Activity indicator to Animate or not.
    @State private var shouldAnimate = true
    /// This State variable is updated to true when sending feedback fails.
    @State private var showingAlert = false
    
    
    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: self.$shouldAnimate)
                .onAppear { self.sendFeedback() }
            Text("Sending the feedback to Prototyper")
        }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"),
                      message: Text("Could not send feedback to server."),
                      dismissButton: .default(Text("OK")) {
                          self.showSendFeedbackView = false
                      })
            }
            .navigationBarTitle("Sending Feedback")
    }
    
    
    /// Sends the feedback to Prototyper and on failure displays the alert
    private func sendFeedback() {
        guard var feedback = feedback else {
            return
        }
        
        feedback.creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        
        apiHandler.send(
            feedback: feedback,
            success: {
                print("Successfully sent feedback to server")
                Prototyper.dismissView()
                Prototyper.currentState.feedbackButtonIsHidden = !Prototyper.settings.showFeedbackButton
            },
            failure: { _ in
                self.shouldAnimate = false
                self.showingAlert = true
            }
        )
    }
}
