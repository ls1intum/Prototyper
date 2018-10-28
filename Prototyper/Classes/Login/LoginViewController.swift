//
//  LoginViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import UIKit

enum LoginState {
    case didNotLogIn
    case logInSuccessful
    case onlyName(userName: String)
}

extension LoginState: Equatable {
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.didNotLogIn, .didNotLogIn):
            return true
        case (.logInSuccessful, .logInSuccessful):
            return true
        case let (.onlyName(lname), .onlyName(rName)):
            return lname == rName
        default:
            return false
        }
    }
}

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidDismiss(withState: LoginState)
}

class LoginViewController: UIViewController {
    
    enum Constants {
        static let unwindSegue = "unwindToFeedbackViewController"
        
        enum StateYourNameAlertSheet {
            static let title = "Please enter your name"
            static let placeholder = "Anonymous"
            static let save = "Save"
        }
        
        enum ErrorAlert {
            static let title = "Error"
            static let message = "Could not log in! Please check your login credentials and try again."
            static let ok = "OK"
        }
    }

    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboardListener()
        loginButton.isEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        APIHandler.sharedAPIHandler.login(id,
                                          password: password,
                                          success: {
            self.navigationController?.dismiss(animated: true, completion: {
                self.delegate?.loginViewControllerDidDismiss(withState: .logInSuccessful)
            })
        }, failure: { _ in
            self.showErrorAlert()
        })
    }
    
    @IBAction private func noLoginButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: Constants.StateYourNameAlertSheet.title, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Constants.StateYourNameAlertSheet.placeholder
            textField.text = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        alertController.addAction(UIAlertAction(title: Constants.StateYourNameAlertSheet.save, style: .default, handler: { _ in
            let name = alertController.textFields?.first?.text ?? ""
            UserDefaults.standard.set(name, forKey: UserDefaultKeys.username)
            
            self.navigationController?.dismiss(animated: true, completion: {
                self.delegate?.loginViewControllerDidDismiss(withState: .onlyName(userName: name))
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
            self.delegate?.loginViewControllerDidDismiss(withState: .didNotLogIn)
        })
    }
    
    @IBAction private func editChanged(_ sender: Any) {
        let id = idTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginButton.isEnabled = !id.isEmpty && !password.isEmpty
    }
    
    
    // MARK: Helper
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: Constants.ErrorAlert.title,
                                                message: Constants.ErrorAlert.message,
                                                preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: Constants.ErrorAlert.ok,
                                          style: .default,
                                          handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - KeyboardReactable

extension LoginViewController: KeyboardReactable {
    func keyboardWillShow(notification: NSNotification) {
        animateKeyboardWillShow(notification, animation: adaptSafeAreaInserts)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateKeyboardWillHide(notification, animation: adaptSafeAreaInserts)
    }
}
