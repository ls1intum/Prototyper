//
//  LoginView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 01.12.19.
//

import SwiftUI


// MARK: LoginView
/// This is an independent View that shows up if the user is not logged in.
struct LoginView: View {
    /// The constant text variables used in the View.
    enum LoginViewConstants {
        enum UserNamePlaceHolder {
            static let withoutLoginText = "TUM-ID/E-Mail"
            static let withLoginText = "Enter your name"
        }
        
        enum SubButtonText {
            static let withoutLoginText = "Continue without login"
            static let withLoginText = "Continue with login"
        }
        
        static let alertText = "Could not log in! Please check your login credentials and try again."
    }
    
    
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    /// <#Description#>
    @EnvironmentObject var apiHandler: APIHandler
    /// Environment variable for presentationMode to dismiss the View.
    @Environment(\.presentationMode) var presentationMode
    
    /// A binding variable to update the calling view once the user has clicked the login button.
    @Binding var finishLoggingIn: Bool
    
    /// The username of the user.
    @State var userid: String = ""
    /// The password of the user.
    @State var password: String = ""
    /// State variable to show or dismiss an alert View.
    @State var showLoginErrorAlert: Bool = false
    /// A boolean to check if the user is proceeding without logging in,
    @State var continueWithoutLogin: Bool = false
    
    
    /// The text to be displayed as placeholder text on the text field.
    var userNamePlaceHolder: String {
        if continueWithoutLogin {
              return LoginViewConstants.UserNamePlaceHolder.withLoginText
        } else {
              return LoginViewConstants.UserNamePlaceHolder.withoutLoginText
        }
    }
    
    /// The text to be displayed on the Login button.
    var subButtonText: String {
        if continueWithoutLogin {
              return LoginViewConstants.SubButtonText.withLoginText
        } else {
              return LoginViewConstants.SubButtonText.withoutLoginText
        }
    }
    
    var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Text("Please log in using your Prototyper/TUM credentials to send feedback")
                        .lineLimit(2)
                }.padding()
                    
                VStack(spacing: 25) {
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
        userid.isEmpty || password.isEmpty ? .gray : .blue
    }
    
    /// The back button displayed at the top left corner of the View.
    private var backButton: some View {
        Button(action: goBack) {
            Text("Cancel").bold()
        }
    }
    
    
    /// Dismisses the LoginView
    private func goBack() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /// Performs login and upon faliure shows the alert.
    private func login() {
        if continueWithoutLogin {
            UserDefaults.standard.set(userid, forKey: UserDefaultKeys.username)
            state.continueWithoutLogin = true
            self.finishLoggingIn = true
            self.presentationMode.wrappedValue.dismiss()
        } else {
            apiHandler.login(userid,
                             password: password,
                             success: { self.presentationMode.wrappedValue.dismiss()
            }, failure: { _ in
                self.showingLoginErrorAlert()
            })
        }
    }
    
    /// Swiches between the two types of login available.
    private func loginSubButton() {
        continueWithoutLogin ? proceedWithLogin() : proceedWithoutLogin()
    }
    
    /// The username and password field appears for the user to login.
    private func proceedWithLogin() {
        continueWithoutLogin = false
        userid = ""
        password = ""
    }
    
    /// The name field appears for the user to continue without logging in.
    private func proceedWithoutLogin() {
        continueWithoutLogin = true
        userid = UserDefaults.standard.string(forKey: UserDefaultKeys.username) ?? ""
        password = "*"
    }
    
    /// Shows the alert when login isn't successful.
    private func showingLoginErrorAlert() {
        showLoginErrorAlert = true
    }
}
