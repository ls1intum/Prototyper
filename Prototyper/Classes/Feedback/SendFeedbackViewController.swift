//
//  SendFeedbackViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // The contract of the `SendFeedbackViewController` requests that a `Feedback` instance should be provided after
    // initializing an instance of `SendFeedbackViewController` and before `viewDidLoad()` is called.
    var feedback: Feedback! // swiftlint:disable:this implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendFeedback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    private func sendFeedback() {
        APIHandler.send(feedback: feedback,
                        success: {
            print("Successfully sent feedback to server")
            PrototyperController.isFeedbackButtonHidden = false
            self.dismiss(animated: true, completion: nil)
        }, failure: { _ in
            self.activityIndicator.stopAnimating()
            let alertController = UIAlertController(title: "Error",
                                                    message: "Could not send feedback to server.",
                                                    preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "Ok",
                                              style: .default,
                                              handler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
