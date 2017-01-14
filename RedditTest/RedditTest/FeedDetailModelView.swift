//
//  FeedDetailModelView.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 13/01/17.
//  Copyright © 2017 Fabio Bermudez. All rights reserved.
//

import Foundation
import UIKit


class FeedDetailModelView : NSObject {
    
    //MARK: - Private Properties

    private let model : Feed

    //MARK: - Public Properties
    
    var tittle : String? {
        get{
            return model.tittle
        }
    }

    var author : String? {
        get{
            return model.author
        }
    }

    var num_comments : String? {
        get{
            return model.num_comments?.stringValue
        }
    }
    
    var date : String? {
        get{
            return model.date?.timeAgoSinceDate()
        }
    }
    
    var image : UIImage? {
        get{
            if let data = model.thumbnailData {
                return UIImage(data: data as Data)
            }
            return nil
        }
    }

    var imageFullUrl : String? {
        get{
            return model.imageFullUrl
        }
    }

    //MARK: - Init
    
    init(newFeed : Feed) {
        self.model = newFeed
    }
    
    
    //MARK: - Public Methods
    
    func getImage(callBackClosure : @escaping (UIImage)->())  {
        ConnectionManager.sharedInstance.gerImageFromServer(model.thumbnail) { [weak self] (imageData : Data?) in
            if let imageData = imageData {
                self?.model.thumbnailData = imageData
                if let image = UIImage(data: imageData) {
                    callBackClosure(image)
                }
            }
        }
    }
    
    func getFullImage(callBackClosure : @escaping (UIImage?)->())  {
        ConnectionManager.sharedInstance.gerImageFromServer(model.imageFullUrl) { [weak self] (imageData : Data?) in
            if let imageData = imageData {
                self?.model.thumbnailData = imageData
                callBackClosure(UIImage(data: imageData))
            }
        }
    }
    
    
}
