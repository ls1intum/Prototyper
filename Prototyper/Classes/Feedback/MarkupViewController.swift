//
//  MarkupViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import UIKit

protocol MarkupViewControllerDelegate: class {
    func didMarkup(image: UIImage)
}

class MarkupViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var markupView: MarkupView!
    
    // The contract of the `MarkupViewController` requests that a background image for the `MarkupViewController`
    // should be provided after initializing an instance of `MarkupViewController` and before `viewDidLoad()` is called.
    var image: UIImage! // swiftlint:disable:this implicitly_unwrapped_optional
    weak var delegate: MarkupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    // MARK: - Actions
    @IBAction private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didMarkup(image: markupView.drawContent(onImage: image))
        self.dismiss(animated: true, completion: nil)
    }
}
