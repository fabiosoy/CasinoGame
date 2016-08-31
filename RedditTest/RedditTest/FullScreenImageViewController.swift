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
            ConnectionManager.sharedInstance.gerImageFromServer(imageUrl) { [weak self] (imageData : NSData?) in
                dispatch_async(dispatch_get_main_queue(),{
                    if let imageData = imageData {
                        if let image = UIImage(data: imageData) {
                            self?.imageView.image = image
                            self?.saveButton.enabled = true
                        } else { self?.imageView.image = UIImage(named:"imageBack") }
                    }
                    self?.activityView.stopAnimating()
                })
            }
        } else { self.imageView.image = UIImage(named:"imageBack")}

    }
    //MARK: - IBActions

    @IBAction func backTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func saveTouched(sender: AnyObject) {
    
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self,#selector(FullScreenImageViewController.image(_:didFinishSavingWithError:contextInfo:)) , nil)
    }
    
    //MARK: - Private Methods

    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
}
