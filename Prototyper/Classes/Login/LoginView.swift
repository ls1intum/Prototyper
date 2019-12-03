//
//  LoginView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var model: Model
    @State var userid: String = ""
    @State var password: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Please log in using your Prototyper/TUM credentials to send feedback")
                        .lineLimit(2)
                }.padding()
                    
                VStack (spacing: 25) {
                    TextField("TUM-ID/E-Mail", text: $userid)
                    SecureField("Password", text: $password)
                    Button(action: login) {
                        Text("Login").bold()
                        .foregroundColor(.white)
                        .padding(8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(buttonColor)
                        .cornerRadius(10)
                    }.disabled(userid.isEmpty || password.isEmpty)
                    Button(action: continueWithoutLogin) {
                        Text("Continue without login").bold()
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text("Could not log in! Please check your login credentials and try again."), dismissButton: .default(Text("OK"), action: {
                            self.model.viewStatus = .shareView
                        }))
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle("Sign In")
            .navigationBarItems(trailing: cancelButton)
        }
    }
    
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel").bold()
        }
    }
    
    var buttonColor: Color {
        return userid.isEmpty || password.isEmpty ? .gray : .blue
    }
    
    private func login() {
        APIHandler.sharedAPIHandler.login(userid,
                                          password: password,
                                          success: {
            self.model.viewStatus = .sendInviteView
        }, failure: { _ in
            self.showErrorAlert()
        })
    }
    
    private func continueWithoutLogin() {
        print("continueWithoutLogin")
    }
    
    private func showErrorAlert() {
        showingAlert = true
    }
    
    private func cancel() {
        model.viewStatus = .shareView
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
