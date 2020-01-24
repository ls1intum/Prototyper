//
//  FeedbackView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.12.19.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var model: Model
    @State var descriptionText: String = ""
    @State var showSheet: Bool = false
    @State var showScreenshot: Bool = true
    @State var activeSheet: ActiveSheet = .loginSheet
    @State var showSendFeedbackView: Bool = false
    @State var feedback: Feedback?
    
    enum ActiveSheet {
        case loginSheet, MarkupSheet
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack (alignment: .top) {
                    if showScreenshot {
                        screenshot
                    }
                    NavigationLink(destination: SendFeedbackView(showSendFeedbackView: $showSendFeedbackView, feedback: $feedback), isActive: $showSendFeedbackView) {
                        Text("")
                    }
                    MultilineTextView(text: $descriptionText, placeholderText: "Add your feedback here...").frame(numLines: 15)
                }
                Spacer()
            }.padding()
            .navigationBarTitle("Give Feedback")
            .navigationBarItems(leading: cancelButton, trailing: shareButton)
            .sheet(isPresented: $showSheet) {
                if self.activeSheet == .loginSheet {
                    NavigationView {
                        LoginView(finishLoggingIn: self.$showSendFeedbackView)
                    }.environmentObject(self.model)
                } else  {
                    NavigationView {
                        EditScreenshotView()
                    }.environmentObject(self.model)
                }
            }
        }
    }
    
    var screenshot: some View {
        ZStack (alignment: .topTrailing) {
            ZStack {
                Image(uiImage: model.screenshotWithMarkup)
                    .resizable()
                    .shadow(color: Color.primary.opacity(0.2), radius: 5.0)
                    .scaledToFit()
                Image(systemName: "pencil.tip.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 50, height: 40, alignment: .center)
                    .onTapGesture {
                        self.editImage()
                }
            }
            Image(systemName: "xmark.circle.fill")
                .imageScale(.large)
                .onTapGesture {
                    self.removeScreenshot()
            }.offset(x: 5)
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
        feedback = currentFeedback
        if APIHandler.sharedAPIHandler.isLoggedIn || model.continueWithoutLogin {
            model.continueWithoutLogin = false
            self.showSendFeedbackView = true
        } else {
            activeSheet = .loginSheet
            self.showSheet = true
        }
    }
    
    private func editImage() {
        activeSheet = .MarkupSheet
        showSheet = true
    }
    
    private func removeScreenshot() {
        showScreenshot = false
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
