//
//  LoginView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI

/// This is an independent View that shows up if the user is not logged in.
struct LoginView: View {
    /// The instance of the Observable Object class named Model,  to share model data anywhere it’s needed.
    @EnvironmentObject var model: Model
    /// Environment variable for presentationMode to dismiss the View.
    @Environment(\.presentationMode) var presentationMode
    /// The username of the user.
    @State var userid: String = ""
    /// The password of the user.
    @State var password: String = ""
    /// State variable to show or dismiss an alert View.
    @State var showLoginErrorAlert: Bool = false
    /// A boolean to check if the user is proceeding without logging in,
    @State var continueWithoutLogin: Bool = false
    /// A binding variable to update the calling view once the user has clicked the login button.
    @Binding var finishLoggingIn: Bool 
    
    /// The constant text variables used in the View.
    enum LoginViewConstants {
        enum userNamePlaceHolder {
            static let withoutLoginText = "TUM-ID/E-Mail"
            static let withLoginText = "Enter your name"
        }
        
        enum subButtonText {
            static let withoutLoginText = "Continue without login"
            static let withLoginText = "Continue with login"
        }
        
        static let alertText = "Could not log in! Please check your login credentials and try again."
    }
    
    /// The text to be displayed as placeholder text on the text field.
    var userNamePlaceHolder: String {
        if continueWithoutLogin {
              return LoginViewConstants.userNamePlaceHolder.withLoginText
        } else {
              return LoginViewConstants.userNamePlaceHolder.withoutLoginText
        }
    }
    
    /// The text to be displayed on the Login button.
    var subButtonText: String {
        if continueWithoutLogin {
              return LoginViewConstants.subButtonText.withLoginText
        } else {
              return LoginViewConstants.subButtonText.withoutLoginText
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
                    if !continueWithoutLogin {
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
                    }.alert(isPresented: $showLoginErrorAlert) {
                        Alert(title: Text("Error"), message: Text(LoginViewConstants.alertText), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                }.padding()
            }
            .navigationBarTitle("Sign In")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
    }
    
    /// The color switch to show that the button is enabled.
    var buttonColor: Color {
        return userid.isEmpty || password.isEmpty ? .gray : .blue
    }
    
    /// The back button displayed at the top left corner of the View.
    private var backButton : some View {
        Button(action: goBack) {
            Text("Cancel").bold()
        }
    }
    
    /// The action to be performed when the back button is pressed.
    private func goBack() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /// This action to be performed when the login button is pressed.
    private func login() {
        if continueWithoutLogin {
            UserDefaults.standard.set(userid, forKey: UserDefaultKeys.username)
            model.continueWithoutLogin = true
            self.finishLoggingIn = true
            self.presentationMode.wrappedValue.dismiss()
        } else {
            APIHandler.sharedAPIHandler.login(userid,
                                              password: password,
                                              success: { self.presentationMode.wrappedValue.dismiss()
            }, failure: { _ in
                self.showingLoginErrorAlert()
            })
        }
    }
    
    /// The action to be performed when the user swiches between the two types of login available.
    private func loginSubButton() {
        continueWithoutLogin ? proceedWithLogin() : proceedWithoutLogin()
    }
    
    /// The action performed when the user wants to login.
    private func proceedWithLogin() {
        continueWithoutLogin = false
        userid = ""
        password = ""
    }
    
    /// The action performed when the user wants to proceed without logging in.
    private func proceedWithoutLogin() {
        continueWithoutLogin = true
        userid = UserDefaults.standard.string(forKey: UserDefaultKeys.username) ?? ""
        password = "*"
    }
    
    /// The action performed when the Login isn't successful.
    private func showingLoginErrorAlert() {
        showLoginErrorAlert = true
    }
}
