//
//  FeedbackViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    enum Constants {
        static let descriptionPlaceholder = "Add your feedback here..."
        static let imageInsert: CGFloat = 16.0
        static let characterLimit = 2500
        
        enum Segues {
            static let send = "sendFeedback"
            static let annotate = "annotateSceenshot"
            static let signIn = "signIn"
        }
    }

    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var annotateButton: UIButton!
    @IBOutlet private weak var removeImageButton: UIButton!
    @IBOutlet private weak var bottomTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendFeedbackBarButtonItem: UIBarButtonItem!
    
    var screenshot: UIImage?
    var currentFeedback: Feedback {
        let description = descriptionTextView.text == Constants.descriptionPlaceholder ? "" : (descriptionTextView.text ?? "")
        
        var creatorName: String?
        if !APIHandler.sharedAPIHandler.isLoggedIn {
            creatorName = UserDefaults.standard.string(forKey: UserDefaultKeys.username)
        }
        
        return Feedback(description: description,
                        screenshot: screenshot,
                        creatorName: creatorName)
    }
    
    // MARK: - (De-)Initializer
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardListener()
        
        PrototyperController.isFeedbackButtonHidden = true
        
        descriptionTextView.text = ""
        let imageViewSize = UIBezierPath(rect: CGRect(x: descriptionTextView.frame.width - imageView.frame.width - Constants.imageInsert,
                                                      y: 0,
                                                      width: imageView.frame.width + Constants.imageInsert,
                                                      height: imageView.frame.height + Constants.imageInsert))
        descriptionTextView.textContainer.exclusionPaths = [imageViewSize]
        textViewDidChange(descriptionTextView)
        
        imageView.image = screenshot
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch (identifier, segue.destination) {
        case (Constants.Segues.send, let sendFeedbackViewController as SendFeedbackViewController):
            sendFeedbackViewController.feedback = currentFeedback
        case (Constants.Segues.signIn, let navigationController as UINavigationController):
            guard let loginViewController = navigationController.topViewController as? LoginViewController else {
                return
            }
            loginViewController.delegate = self
        case (Constants.Segues.annotate, let navigationController as UINavigationController):
            guard let markupViewController = navigationController.topViewController as? MarkupViewController else {
                return
            }
            markupViewController.delegate = self
            markupViewController.image = screenshot
        default:
            print("Unknown Segue")
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func removeImageButtonPressed(_ sender: UIButton) {
        screenshot = nil
        annotateButton.isHidden = true
        removeImageButton.isHidden = true
        imageView.isHidden = true
        descriptionTextView.textContainer.exclusionPaths = []
    }
    
    @IBAction private func sendButtonPressed(_ sender: Any) {
        if APIHandler.sharedAPIHandler.isLoggedIn {
            performSegue(withIdentifier: Constants.Segues.send, sender: self)
        } else {
            performSegue(withIdentifier: Constants.Segues.signIn, sender: self)
        }
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
            PrototyperController.isFeedbackButtonHidden = false
        })
    }
}

// MARK: - TextViewDelegate

extension FeedbackViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Constants.descriptionPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.descriptionPlaceholder
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
            sendFeedbackBarButtonItem.isEnabled = screenshot != nil
        } else {
            sendFeedbackBarButtonItem.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= Constants.characterLimit
    }
}

// MARK: - KeyboardReactable

extension FeedbackViewController: KeyboardReactable {
    func keyboardWillShow(notification: NSNotification) {
        animateKeyboardWillShow(notification, animation: adaptSafeAreaInserts)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateKeyboardWillHide(notification, animation: adaptSafeAreaInserts)
    }
}

// MARK: - LoginViewControllerDelegate

extension FeedbackViewController: LoginViewControllerDelegate {
    func loginViewControllerDidDismiss(withState: LoginState) {
        if withState != LoginState.didNotLogIn {
            performSegue(withIdentifier: Constants.Segues.send, sender: self)
        }
    }
}

// MARK: - MarkupViewControllerDelegate

extension FeedbackViewController: MarkupViewControllerDelegate {
    func didMarkup(image: UIImage) {
        screenshot = image
        imageView.image = image
    }
}
