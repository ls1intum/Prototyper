//
//  ShareViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    struct Constants {
        static let contentPlaceholder = "This is the content of the invitation..."
        
        struct segues {
            static let signIn = "signIn"
            static let send = "sendShareRequest"
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    var currentShareRequest: ShareRequest {
        let content = contentTextView.text == Constants.contentPlaceholder ? "" : contentTextView.text!
        
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.Username)
        }
        
        return ShareRequest(email: emailTextField.text!,
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
        case Constants.segues.signIn:
            guard let navigationController = segue.destination as? UINavigationController,
                let loginViewController = navigationController.topViewController as? LoginViewController else {
                    return
            }
            loginViewController.delegate = self
        case Constants.segues.send:
            guard let sendShareRequestViewController = segue.destination as? SendShareRequestViewController else {
                return
            }
            sendShareRequestViewController.shareRequest = currentShareRequest
        default:
            print("Unknown Segue")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        PrototyperController.isFeedbackButtonHidden = false
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            performSegue(withIdentifier: Constants.segues.send, sender: self)
        } else {
            performSegue(withIdentifier: Constants.segues.signIn, sender: self)
        }
    }
    
    @IBAction func editChanged(_ sender: UITextField) {
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
    func LoginViewControllerDidDismiss(withState state: LoginState) {
        if state != .didNotLogIn {
            performSegue(withIdentifier: Constants.segues.send, sender: self)
        }
    }
}
