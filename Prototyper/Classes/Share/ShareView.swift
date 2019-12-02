//
//  ShareView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 30.11.19.
//

import SwiftUI

struct ShareView: View {
    @EnvironmentObject var model: Model
    @State var inviteList: String = ""
    @State var inviteText: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                VStack (alignment: .leading, spacing: 25) {
                    Text("Send the invitation to test the app to:")
                    TextField("email@example.com", text: $inviteList)
                    Text("Invitation Text:")
                    TextField("This is the content of the invitation...", text: $inviteText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                VStack {
                    Button(action: share) {
                        Text("Share").bold()
                        .foregroundColor(.white)
                        .padding(8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(buttonColor)
                        .cornerRadius(10)
                    }.disabled(inviteList.isEmpty || !inviteList.isValidEmail)
                }
            }.padding(20)
            .navigationBarTitle("Share App")
            .navigationBarItems(trailing: cancelButton)
        }
    }
    
    private var currentShareRequest: ShareRequest {
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return ShareRequest(email: inviteList,
                            content: inviteText,
                            creatorName: creatorName)
    }
    
    var buttonColor: Color {
        return inviteList.isEmpty || !inviteList.isValidEmail ? .gray : .blue
    }
    
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel").bold()
        }
    }
    
    private func cancel() {
        PrototyperController.dismissView()
        PrototyperController.isFeedbackButtonHidden = false
    }
    
    private func share() {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            print("Send screen")
            PrototyperController.currentShareRequest = currentShareRequest
            model.viewStatus = .sendInviteView
        } else {
            print("SignIn screen")
            PrototyperController.currentShareRequest = currentShareRequest
            model.viewStatus = .loginView
        }
    }
}

struct Share_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
