//
//  FeedbackView.swift
//  Prototyper
//
//  Created by Raymond Pinto on 20.12.19.
//
import SwiftUI


// MARK: FeedbackView
/// This View holds the markup image and the feedback text field for the user to send feedback.
struct FeedbackView: View {
    /// The instance of the Observable Object class named Model,  to share state data anywhere it’s needed.
    @EnvironmentObject var state: PrototyperState
    
    /// This State variable holds the feedback text.
    @State var descriptionText: String = ""
    /// This State variable is updated when the Send button is pressed.
    @State var showSheet: Bool = false
    /// This State variable is used to tell the View if the screenshot needs to be sent as feedback or not.
    @State var showScreenshot: Bool = true
    /// This State variable when set to true sends the Feedback to Prototyper.
    @State var showSendFeedbackView: Bool = false
    /// The variable holds the image and the feedback text to be sent.
    @State var feedback: Feedback?
    /// Stores the old value set as a preference for `UITextView.appearance().backgroundColor` so we can show a placeholder behind the view
    @State var oldTextViewColor: UIColor?
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top) {
                    if showScreenshot {
                        screenshot
                    }
                    NavigationLink(destination: SendFeedbackView(showSendFeedbackView: $showSendFeedbackView,
                                                                 feedback: $feedback),
                                   isActive: $showSendFeedbackView) {
                        Text("")
                    }
                    ZStack(alignment: .topLeading) {
                        if descriptionText.isEmpty {
                            Text("Add your feedback here...")
                                .foregroundColor(Color(.systemGray3))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $descriptionText)
                            .onAppear {
                                oldTextViewColor = UITextView.appearance().backgroundColor
                                UITextView.appearance().backgroundColor = .clear
                            }
                            .onDisappear {
                                UITextView.appearance().backgroundColor = oldTextViewColor
                            }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle("Give Feedback")
            .navigationBarItems(leading: cancelButton, trailing: sendButton)
            .sheet(isPresented: $showSheet) {
                NavigationView {
                    EditScreenshotView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(self.state)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// The screenshot displayed on the FeedbackView with a Markup and delete button
    var screenshot: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                Image(uiImage: state.getScreenshotWithMarkup())
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
                }
                .offset(x: 5)
        }
    }
    
    /// Holds the screenshot and the feedback text to be sent to Prototyper
    var currentFeedback: Feedback {
        var creatorName: String?
        if state.apiHandler.userIsLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return Feedback(description: descriptionText,
                        screenshot: state.screenshotWithMarkup,
                        creatorName: creatorName)
    }
    
    /// The cancel button displayed at the top left of the View
    private var cancelButton : some View {
        Button(action: cancel) {
            Text("Cancel")
        }
    }
    
    /// The send Button displayed at the top right of the View
    private var sendButton : some View {
        Button(action: send) {
            Text("Send").bold()
        }
    }
    
    
    /// Dismisses the view and makes the Feedback bubble appear again.
    private func cancel() {
        Prototyper.dismissView()
        state.setFeedbackButtonIsHidden()
    }
    
    /// Sends the feedback to Prototyper via the SendFeedbackView
    private func send() {
        feedback = currentFeedback
        self.showSendFeedbackView = true
    }
    
    /// Brings up the EditScreenShotView to Markup the screenshot
    private func editImage() {
        showSheet = true
    }
    
    /// Deletes the screenshot from the View
    private func removeScreenshot() {
        showScreenshot = false
    }
}


// MARK: FeedbackView + Preview
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
