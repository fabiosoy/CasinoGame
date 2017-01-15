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
    
    override func refreshView() {
        DispatchQueue.main.async(execute: {
            super.refreshView()
            self.collection.reloadData()
        })
    }
    
    //MARK: - Collection View Delegate - Collection View DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedModelView.getElementsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let object = self.feedModelView.getElementForRow(row: indexPath.row)
        cell.setModel(object,delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let object = self.feedModelView.getElementForRow(row: indexPath.row)
        let rect = object.tittle?.boundingRect(with: CGSize(width: CollectionLayoutConfig.CELL_WIDTH,height: CollectionLayoutConfig.TEXT_MAX_HEIGHT), options:.usesLineFragmentOrigin, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: CollectionLayoutConfig.FONT_SIZE)], context:nil)
        return CGSize(width:CollectionLayoutConfig.CELL_WIDTH , height:CollectionLayoutConfig.CELL_MIN_HEIGHT + rect!.size.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // Method for managing the pagination and request more data when it is in the bottom.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - self.collection.frame.size.height
        if actualPosition > contentHeight && self.refreshControl.isRefreshing == false {
            if self.feedModelView.requestData(reload: false, callBack: {
                self.showLoadinViews(show: false)
                self.refreshView()
            }) {
                self.showLoadinViews(show: true)
            }
        }
    }
    
}
