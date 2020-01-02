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
    
    enum Constants {
        static let descriptionPlaceholder = "Add your feedback here..."
        static let imageInsert: CGFloat = 16.0
        static let characterLimit = 2500
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
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
                    }
                    VStack {
                        ZStack {
                            MultilineTextView(text: $descriptionText)
                            .frame(maxHeight: .infinity)
                            if descriptionText.isEmpty {
                                Text("Enter your feedback here...").foregroundColor(.gray)
                                    .opacity(0.75).onTapGesture {
                                    self.descriptionText = " "
                                }
                            }
                        }
                    }
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
            //PrototyperController.currentShareRequest = currentShareRequest
            //self.model.showSendInviteView = true
        } else {
            print("SignIn screen")
            //PrototyperController.currentShareRequest = currentShareRequest
            //self.model.showLoginView = true
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
