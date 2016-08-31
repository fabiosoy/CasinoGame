//
//  CollectionViewController.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit

class CollectionViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: - IBOutlets

    @IBOutlet weak var collection: UICollectionView!
    
    //MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.addSubview(self.refreshControl)
    }
    
    override func reloadView() {
        self.collection.reloadData()
    }
    
    //MARK: - Collection View Delegate - Collection View DataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let object = dataList[indexPath.row]
        cell.setModel(object,delegate: self)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let object = dataList[indexPath.row]
        let rect = object.tittle?.boundingRectWithSize(CGSizeMake(CollectionLayoutConfig.CELL_WIDTH,CollectionLayoutConfig.TEXT_MAX_HEIGHT), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:[NSFontAttributeName: UIFont.systemFontOfSize(CollectionLayoutConfig.FONT_SIZE)], context:nil)
        return CGSize(width:CollectionLayoutConfig.CELL_WIDTH , height:CollectionLayoutConfig.CELL_MIN_HEIGHT + rect!.size.height )
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - self.collection.frame.size.height
        if actualPosition > contentHeight && self.refreshControl.refreshing == false {
            self.requestData()
        }
    }
    
}
