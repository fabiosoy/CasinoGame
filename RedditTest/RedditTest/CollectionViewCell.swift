//
//  CollectionViewCell.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit



class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private Properties

    private weak var delegateCollectionViewCell : ThumbnailInteractionDelegate?
    private var feedModel : Feed?

    //MARK: - IBOutlets

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentQtyLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    //MARK: - Cell

    func initCell() {
        tittleLabel.text = ""
        authorLabel.text = ""
        dateLabel.text = ""
        commentQtyLabel.text = ""
        thumbnailImageView.image = UIImage(named:"imageBack")
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initCell()
    }
    
    
    func setModel(model : Feed, delegate : ThumbnailInteractionDelegate) {
        feedModel = model
        delegateCollectionViewCell = delegate
        tittleLabel.text = model.tittle
        authorLabel.text = model.author
        commentQtyLabel.text = model.num_comments?.stringValue
        dateLabel.text = model.date?.timeAgoSinceDate()
        if let data = model.thumbnailData {
            self.thumbnailImageView.image = UIImage(data: data)
        } else {
            ConnectionManager.sharedInstance.gerImageFromServer(model.thumbnail) { [weak self] (imageData : NSData?) in
                if let imageData = imageData {
                    model.thumbnailData = imageData
                    dispatch_async(dispatch_get_main_queue(),{
                        self?.thumbnailImageView.image = UIImage(data: imageData)
                    })
                }
            }
        }
    }

    @IBAction func thumbnailTouched(sender: AnyObject) {
        guard let delegate = delegateCollectionViewCell else { return }
        guard let model = feedModel else { return }
        delegate.thumbnailTouched(model)
    }
}
