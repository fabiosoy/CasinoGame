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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let object = dataList[indexPath.row]
        cell.setModel(object,delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let object = dataList[indexPath.row]
        let rect = object.tittle?.boundingRect(with: CGSize(width: CollectionLayoutConfig.CELL_WIDTH,height: CollectionLayoutConfig.TEXT_MAX_HEIGHT), options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: CollectionLayoutConfig.FONT_SIZE)], context:nil)
        return CGSize(width:CollectionLayoutConfig.CELL_WIDTH , height:CollectionLayoutConfig.CELL_MIN_HEIGHT + rect!.size.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - self.collection.frame.size.height
        if actualPosition > contentHeight && self.refreshControl.isRefreshing == false {
            self.requestData()
        }
    }
    
}
