//
//  MarkupViewController.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 10/31/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import UIKit

protocol MarkupViewControllerDelegate {
    func didMarkup(image: UIImage)
}

class MarkupViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var markupView: MarkupView!
    
    var image: UIImage!
    var delegate: MarkupViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didMarkup(image: markupView.drawContent(onImage: image))
        self.dismiss(animated: true, completion: nil)
    }
}
