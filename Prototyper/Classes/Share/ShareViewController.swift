//
//  ShareViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    enum Constants {
        static let contentPlaceholder = "This is the content of the invitation..."
        
        enum Segues {
            static let signIn = "signIn"
            static let send = "sendShareRequest"
        }
    }
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var shareButton: UIButton!
    
    var currentShareRequest: ShareRequest {
        let content = contentTextView.text == Constants.contentPlaceholder ? "" : (contentTextView.text ?? "")
        
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return ShareRequest(email: emailTextField.text ?? "",
                            content: content,
                            creatorName: creatorName)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardListener()
        
        PrototyperController.isFeedbackButtonHidden = true
        contentTextView.text = ""
        textViewDidChange(contentTextView)
        shareButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Constants.Segues.signIn:
            guard let navigationController = segue.destination as? UINavigationController,
                let loginViewController = navigationController.topViewController as? LoginViewController else {
                    return
            }
            loginViewController.delegate = self
        case Constants.Segues.send:
            guard let sendShareRequestViewController = segue.destination as? SendShareRequestViewController else {
                return
            }
            sendShareRequestViewController.shareRequest = currentShareRequest
        default:
            print("Unknown Segue")
        }
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        PrototyperController.isFeedbackButtonHidden = false
    }
    
    @IBAction private func shareButtonPressed(_ sender: Any) {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            performSegue(withIdentifier: Constants.Segues.send, sender: self)
        } else {
            performSegue(withIdentifier: Constants.Segues.signIn, sender: self)
        }
    }
    
    @IBAction private func editChanged(_ sender: UITextField) {
        guard let email = emailTextField.text else {
            return
        }
        
        shareButton.isEnabled = !email.isEmpty && email.isValidEmail
    }
}

// MARK: - UITextViewDelegate

extension ShareViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constants.contentPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.contentPlaceholder
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
        }
    }
}

// MARK: - KeyboardReactable

extension ShareViewController: KeyboardReactable {
    func keyboardWillShow(notification: NSNotification) {
        animateKeyboardWillShow(notification, animation: adaptSafeAreaInserts)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateKeyboardWillHide(notification, animation: adaptSafeAreaInserts)
    }
}

// MARK: - UITextViewDelegate

extension ShareViewController: LoginViewControllerDelegate {
    func loginViewControllerDidDismiss(withState state: LoginState) {
        if state != .didNotLogIn {
            performSegue(withIdentifier: Constants.Segues.send, sender: self)
        }
    }
}
