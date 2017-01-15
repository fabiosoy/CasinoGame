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
    var selectedModelView : FeedItemModelView?
    let showFullScreen = "showFullScreen"
    var feedModelView : FeedModelView {
        get{
            return (self.tabBarController as! TabBarViewController).feedModelView
        }
    }

    //MARK: - IBOutlets

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - View Controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(BaseViewController.refreshData), for:UIControlEvents.valueChanged)
        if selectedModelView != nil { selectedModelView = nil }
        else {
            if self.feedModelView.getElementsCount() > 0 {
                self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
                self.refreshView()
            } else {
                do {
                    try self.feedModelView.requestData(reload: true, callBack: {
                        self.showLoadinViews(show: false)
                        self.refreshView()
                    })
                } catch  {
                    print(error)
                }
            }
        }
    }
    
    func getMoreData()  {
        do {
            self.showLoadinViews(show: true)
            try self.feedModelView.requestData(reload: false, callBack: {
                self.showLoadinViews(show: false)
                self.refreshView()
            })
        } catch  {
            switch error {
            case RequestDataErrors.isLoading:
                print(error)
            default:
                self.showLoadinViews(show: false)
            }
        }
    }
    
    func refreshData()  {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.feedModelView.searchText = ""
        self.showLoadinViews(show: true)
        do {
            try self.feedModelView.requestData(reload: true, callBack: {
                self.showLoadinViews(show: false)
                self.refreshView()
            })
        } catch  {
            switch error {
            case RequestDataErrors.noConnection:
                self.showLoadinViews(show: false)
            default:
                print(error)
            }
        }
        
        self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
        self.refreshView()
    }
    
    // MARK: - Thumbnail Interaction Delegate
    func thumbnailTouched(_ modelView: FeedItemModelView) {
        selectedModelView = modelView
        self.performSegue(withIdentifier: showFullScreen, sender:self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FullScreenImageViewController {
            controller.feedItemModelView = selectedModelView
        }
    }
    
    // MARK: - Internal Methods
  
    func refreshView() {
        self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
    }
    
    func showLoadinViews(show : Bool)  {
        DispatchQueue.main.async(execute: {
            if show {
                if self.refreshControl.isRefreshing == false {
                    self.activityIndicatorView.isHidden = false
                    self.activityIndicatorView.startAnimating()
                }
            } else {
                self.activityIndicatorView.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    // MARK: -  Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.feedModelView.searchText = searchText
        self.refreshView()
    }
    
    
    

}
