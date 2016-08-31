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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.backgroundColor = UIColor.purpleColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(BaseViewController.renewData), forControlEvents:UIControlEvents.ValueChanged)
        fullDataList = feedManager.getStoredFeed()
        if selectedModel != nil { selectedModel = nil }
        else {
            if fullDataList.count > 0 {
                dataList = Array<Feed>(fullDataList)
                self.searchBar.placeholder = "Numbers of Articles ".stringByAppendingString(String(dataList.count))
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
        self.searchBar.placeholder = "Numbers of Articles ".stringByAppendingString("0")
        self.reloadView()
        self.requestData()
    }
    
    // MARK: - Thumbnail Interaction Delegate
    func thumbnailTouched(model: Feed) {
        selectedModel = model
        self.performSegueWithIdentifier("showFullScreen", sender:self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullScreen" {
            let controller = segue.destinationViewController as! FullScreenImageViewController
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
        if self.refreshControl.refreshing == false {
            activityIndicatorView.hidden = false
            activityIndicatorView.startAnimating()
        }
        feedManager.getFeed { [weak self](error : NSError?, list : [Feed]) in
            guard error == nil else {
                return
            }
            if let selfInstance = self {
                if list.count > 0 {
                    selfInstance.fullDataList.removeAll()
                    selfInstance.fullDataList.appendContentsOf(list)
                    selfInstance.dataList = Array<Feed>(selfInstance.fullDataList)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    selfInstance.reloadView()
                    selfInstance.activityIndicatorView.stopAnimating()
                    selfInstance.loadingData = false
                    selfInstance.searchBar.placeholder = "Numbers of Articles ".stringByAppendingString(String(list.count))
                    selfInstance.refreshControl.endRefreshing()
                })
            }
        }
    }
    
    func reloadView() {
        preconditionFailure("This method must be overridden")
    }
    
    // MARK: -  Search Bar Delegate
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        guard text != "\n" else {
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.characters.count > 0 {
            let filteredArray = fullDataList.filter() { $0.tittle?.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil }
            dataList = Array<Feed>(filteredArray)
        } else {
            dataList = Array<Feed>(fullDataList)
        }
        self.reloadView()
        
    }
    

}
