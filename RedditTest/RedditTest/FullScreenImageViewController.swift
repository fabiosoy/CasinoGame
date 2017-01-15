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
    
    var modelDetailView : FeedDetailModelView?

    //MARK: - IBOutlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    //MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityView.stopAnimating()
        self.imageView.image = UIImage(named:"imageBack")
        if let image = modelDetailView?.imageFull {
            self.imageView.image = image
        } else {
            self.activityView.startAnimating()
            modelDetailView?.getFullImage(callBackClosure: { [weak self] (image : UIImage?) in
                DispatchQueue.main.async(execute: {
                    if let image = image {
                        self?.imageView.image = image
                        self?.saveButton.isEnabled = true
                    }
                    self?.activityView.stopAnimating()
                })
            })
        }
    }
    //MARK: - IBActions

    @IBAction func backTouched(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func saveTouched(_ sender: AnyObject) {
    
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self,#selector(FullScreenImageViewController.image(_:didFinishSavingWithError:contextInfo:)) , nil)
    }
    
    //MARK: - Private Methods

    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo:UnsafeRawPointer) {
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
