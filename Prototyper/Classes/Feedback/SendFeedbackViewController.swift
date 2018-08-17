//
//  SendFeedbackViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import UIKit

class SendFeedbackViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var feedback: Feedback!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendFeedback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    private func sendFeedback() {
        APIHandler.send(feedback: feedback, success: {
            print("Successfully sent feedback to server")
            PrototyperController.isFeedbackButtonHidden = false
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error) in
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

