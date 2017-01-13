//
//  BaseViewController.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UISearchBarDelegate,ThumbnailInteractionDelegate {
    
    //MARK: - Private Properties
    var refreshControl = UIRefreshControl()    
    var dataList = Array<Feed>()
    var fullDataList = Array<Feed>()
    let feedManager = FeedManager.sharedInstance
    var selectedModel : Feed?
    var loadingData = false

    //MARK: - IBOutlets

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - View Controller
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(BaseViewController.renewData), for:UIControlEvents.valueChanged)
        fullDataList = feedManager.getStoredFeed()
        if selectedModel != nil { selectedModel = nil }
        else {
            if fullDataList.count > 0 {
                dataList = Array<Feed>(fullDataList)
                self.searchBar.placeholder = "Numbers of Articles " + String(dataList.count)
                self.reloadView()
            } else {
                self.requestData()
            }
        }
    }
    
    func renewData()  {
        feedManager.deleteAllData()
        fullDataList.removeAll()
        dataList.removeAll()
        self.searchBar.placeholder = "Numbers of Articles " + "0"
        self.reloadView()
        self.requestData()
    }
    
    // MARK: - Thumbnail Interaction Delegate
    func thumbnailTouched(_ model: Feed) {
        selectedModel = model
        self.performSegue(withIdentifier: "showFullScreen", sender:self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFullScreen" {
            let controller = segue.destination as! FullScreenImageViewController
            controller.model = selectedModel
        }
    }
    
    // MARK: - Internal Methods
    func requestData()  {
        guard loadingData == false &&
            fullDataList.count < Config.max_items &&
            searchBar.text?.characters.count == 0 else {
            return
        }
        loadingData = true
        if self.refreshControl.isRefreshing == false {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
        feedManager.getFeed { [weak self](error : Error?, list : [Feed]) in
            guard error == nil else {
                return
            }
            if let selfInstance = self {
                if list.count > 0 {
                    selfInstance.fullDataList.removeAll()
                    selfInstance.fullDataList.append(contentsOf: list)
                    selfInstance.dataList = Array<Feed>(selfInstance.fullDataList)
                }
                DispatchQueue.main.async(execute: {
                    selfInstance.reloadView()
                    selfInstance.activityIndicatorView.stopAnimating()
                    selfInstance.loadingData = false
                    selfInstance.searchBar.placeholder = "Numbers of Articles " + String(list.count)
                    selfInstance.refreshControl.endRefreshing()
                })
            }
        }
    }
    
    func reloadView() {
        preconditionFailure("This method must be overridden")
    }
    
    // MARK: -  Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text != "\n" else {
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.characters.count > 0 {
            let filteredArray = fullDataList.filter() { $0.tittle?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil }
            dataList = Array<Feed>(filteredArray)
        } else {
            dataList = Array<Feed>(fullDataList)
        }
        self.reloadView()
        
    }
    

}
