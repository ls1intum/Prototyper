//
//  LoginView.swift
//  KeychainSwift
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    @State var userid: String = ""
    @State var password: String = ""
    @State var showingAlert: Bool = false
    @State var continueWithoutLoginState: Bool = false
    @State var alertText: String = "Could not log in! Please check your login credentials and try again."
    @State var userNamePlaceHolder = LoginViewConstants.userNamePlaceHolder.withoutLoginText
    @State var subButtonText = LoginViewConstants.subButtonText.withoutLoginText
    
    enum LoginViewConstants {
        enum userNamePlaceHolder {
            static let withoutLoginText = "TUM-ID/E-Mail"
            static let withLoginText = "Enter your name"
        }
        
        enum subButtonText {
            static let withoutLoginText = "Continue without login"
            static let withLoginText = "Continue with login"
        }
    }
    
    var body: some View {
            VStack {
                VStack (alignment: .leading) {
                    Text("Please log in using your Prototyper/TUM credentials to send feedback")
                        .lineLimit(2)
                }.padding()
                    
                VStack (spacing: 25) {
                    TextField(userNamePlaceHolder, text: $userid)
                    if !continueWithoutLoginState {
                        SecureField("Password", text: $password)
                    }
                    Button(action: login) {
                        Text("Login").bold()
                        .foregroundColor(.white)
                        .padding(8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(buttonColor)
                        .cornerRadius(10)
                    }.disabled(userid.isEmpty || password.isEmpty)
                    Button(action: loginSubButton) {
                        Text(subButtonText).bold()
                    }.alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertText), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle("Sign In")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
    }
    
    var buttonColor: Color {
        return userid.isEmpty || password.isEmpty ? .gray : .blue
    }
    
    private var backButton : some View {
        Button(action: goBack) {
            Text("Cancel").bold()
        }
    }
    
    private func goBack() {
        self.model.showLoginView = false
    }
    
    private func login() {
        if continueWithoutLoginState {
            UserDefaults.standard.set(userid, forKey: UserDefaultKeys.username)
            self.model.showLoginView = false
            self.presentationMode.wrappedValue.dismiss()
            self.model.showSendInviteView = true
        } else {
            APIHandler.sharedAPIHandler.login(userid,
                                              password: password,
                                              success: {
                                                self.model.showLoginView = false
                                                self.presentationMode.wrappedValue.dismiss()
                                                self.model.showSendInviteView = true
            }, failure: { _ in
                self.showErrorAlert()
            })
        }
    }
    
    private func loginSubButton() {
        continueWithoutLoginState ? continueWithLogin() : continueWithoutLogin()
    }
    
    private func continueWithLogin() {
        continueWithoutLoginState = false
        userNamePlaceHolder =  LoginViewConstants.userNamePlaceHolder.withoutLoginText
        subButtonText = LoginViewConstants.subButtonText.withoutLoginText
        userid = ""
        password = ""
    }
    
    private func continueWithoutLogin() {
        continueWithoutLoginState = true
        userNamePlaceHolder = LoginViewConstants.userNamePlaceHolder.withLoginText
        subButtonText = LoginViewConstants.subButtonText.withLoginText
        userid = UserDefaults.standard.string(forKey: UserDefaultKeys.username) ?? ""
        password = "*"
    }
    
    private func showErrorAlert() {
        showingAlert = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
