//
//  SendFeedbackView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 02.01.20.
//

import SwiftUI

struct SendFeedbackView: View {
    @EnvironmentObject var model: Model
    @State private var shouldAnimate = true
    @State private var showingAlert = false
    @Binding var showSendFeedbackView: Bool
    @Binding var feedback: Feedback?
    
    var body: some View {
        VStack {
            ActivityIndicator(isAnimating: self.$shouldAnimate)
                .onAppear { self.sendFeedback() }
            Text("Sending the feedback to Prototyper")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Could not send feedback to server."), dismissButton: .default(Text("OK"), action: {
                self.showSendFeedbackView = false
            }))
        }.navigationBarTitle("Sending Feedback")
    }
    
    private func sendFeedback() {
        guard let feedback = feedback else {
            return
        }
        
        APIHandler.send(feedback: feedback,
            success: {
                print("Successfully sent feedback to server")
                PrototyperController.isFeedbackButtonHidden = false
                PrototyperController.dismissView()
        },  failure: { _ in
                self.shouldAnimate = false
                self.showingAlert = true
        })
    }
}
