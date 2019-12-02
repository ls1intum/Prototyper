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
    @State var shareRequest: ShareRequest = PrototyperController.currentShareRequest
    
    var body: some View {
        NavigationView {
            VStack {
                ActivityIndicator(isAnimating: self.$shouldAnimate)
                    .onAppear { self.sendShareRequest() }
                Text("Sending the invitation to Prototyper")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Could not send feedback to server."), dismissButton: .default(Text("OK"), action: {
                    self.model.viewStatus = .shareView
                }))
            }
        }.navigationBarTitle("Sending Invitation")
    }
    
    private func sendShareRequest() {
        guard let shareRequest = shareRequest else {
            return
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

struct ShareInvite_Previews: PreviewProvider {
    static var previews: some View {
        SendInviteView()
    }
}