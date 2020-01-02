//
//  FeedbackView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 20.12.19.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var model: Model
    @State var descriptionText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .top) {
                    ZStack {
                        Image(uiImage: model.screenshot)
                            .resizable()
                            .border(Color(white: 0.75))
                            .scaledToFit()
                        Image(systemName: "hand.draw")
                            .imageScale(.large)
                            .onTapGesture {
                                self.editImage()
                        }
                        NavigationLink(destination: LoginView(), isActive: $model.showLoginView) {
                            Text("")
                        }
                        NavigationLink(destination: SendFeedbackView(), isActive: $model.showSendInviteView) {
                            Text("")
                        }
                    }
                    MultilineTextView(text: $descriptionText, placeholderText: "Add your feedback here...").frame(numLines: 15)
                }
                Spacer()
            }.padding()
            .navigationBarTitle("Write Feedback")
                .navigationBarItems(leading: cancelButton, trailing: shareButton)
        }
    }
    
    var currentFeedback: Feedback {
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return Feedback(description: descriptionText,
                        screenshot: model.screenshot,
                        creatorName: creatorName)
    }
    
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel").bold()
        }
    }
    
    private var shareButton : some View {
        Button(action: share) {
            Text("Share").bold()
        }
    }
    
    private func cancel() {
        PrototyperController.dismissView()
        PrototyperController.isFeedbackButtonHidden = false
    }
    
    private func share() {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            print("Send screen")
            PrototyperController.feedback = currentFeedback
            self.model.showSendInviteView = true
        } else {
            print("SignIn screen")
            PrototyperController.feedback = currentFeedback
            self.model.showLoginView = true
        }
    }
    
    private func editImage() {
        PrototyperController.dismissView()
        PrototyperController.isFeedbackButtonHidden = false
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
