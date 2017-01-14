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

    fileprivate weak var delegateCollectionViewCell : ThumbnailInteractionDelegate?
    fileprivate var feedModel : FeedDetailModelView?

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
        self.layer.borderColor = UIColor.white.cgColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initCell()
    }
    
    
    func setModel(_ model : FeedDetailModelView, delegate : ThumbnailInteractionDelegate) {
        feedModel = model
        delegateCollectionViewCell = delegate
        tittleLabel.text = model.tittle
        authorLabel.text = model.author
        commentQtyLabel.text = model.num_comments
        dateLabel.text = model.date
        if let image = model.image {
            self.thumbnailImageView.image = image
        } else {
            self.feedModel?.getImage(callBackClosure: { [weak self] (image : UIImage) in
                if let selfInstance = self {
                    DispatchQueue.main.async(execute: {
                        selfInstance.thumbnailImageView.image = image
                    })
                }
            })
        }
    }

    @IBAction func thumbnailTouched(_ sender: AnyObject) {
        guard let delegate = delegateCollectionViewCell else { return }
        guard let model = feedModel else { return }
        delegate.thumbnailTouched(model)
    }
}
