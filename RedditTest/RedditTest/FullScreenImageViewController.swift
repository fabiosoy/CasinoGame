//
//  FullScreenImageViewController.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    //MARK: - Properties
    
    var model : Feed?

    //MARK: - IBOutlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    //MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl = model?.imageFullUrl {
            activityView.startAnimating()
            ConnectionManager.sharedInstance.gerImageFromServer(imageUrl) { [weak self] (imageData : Data?) in
                DispatchQueue.main.async(execute: {
                    if let imageData = imageData {
                        if let image = UIImage(data: imageData) {
                            self?.imageView.image = image
                            self?.saveButton.isEnabled = true
                        } else { self?.imageView.image = UIImage(named:"imageBack") }
                    }
                    self?.activityView.stopAnimating()
                })
            }
        } else { self.imageView.image = UIImage(named:"imageBack")}

    }
    //MARK: - IBActions

    @IBAction func backTouched(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func saveTouched(_ sender: AnyObject) {
    
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self,#selector(FullScreenImageViewController.image(_:didFinishSavingWithError:contextInfo:)) , nil)
    }
    
    //MARK: - Private Methods

    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
}
