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
    var selectedModelView : FeedDetailModelView?
    var feedModelView : FeedModelView!
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarViewController {
            self.feedModelView = tabBarController.feedModelView
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(BaseViewController.renewData), for:UIControlEvents.valueChanged)
        if selectedModelView != nil { selectedModelView = nil }
        else {
            if self.feedModelView.getElementsCount() > 0 {
                self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
                self.reloadView()
            } else {
                _ = self.feedModelView.requestData(reload: true, callBack: {
                    self.showLoadinViews(show: false)
                    self.reloadView()
                })
            }
        }
    }
    
    func showLoadinViews(show : Bool)  {
        if show {
            if self.refreshControl.isRefreshing == false {
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async(execute: {
                self.activityIndicatorView.stopAnimating()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    func renewData()  {
        self.showLoadinViews(show: true)
        _ = self.feedModelView.requestData(reload: true) {
            self.showLoadinViews(show: false)
            self.reloadView()
        }
        self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
        self.reloadView()
    }
    
    // MARK: - Thumbnail Interaction Delegate
    func thumbnailTouched(_ modelView: FeedDetailModelView) {
        selectedModelView = modelView
        self.performSegue(withIdentifier: "showFullScreen", sender:self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFullScreen" {
            let controller = segue.destination as! FullScreenImageViewController
            controller.modelDetailView = selectedModelView
        }
    }
    
    // MARK: - Internal Methods
  
    func reloadView() {
        self.searchBar.placeholder = self.feedModelView.numbersOfArticlesText
    }
    
    // MARK: -  Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.feedModelView.searchText = searchText
        self.reloadView()
    }
    
    
    

}
