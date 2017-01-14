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
    var selectedModel : FeedDetailModelView?
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
        if selectedModel != nil { selectedModel = nil }
        else {
            if self.feedModelView.getElementsCount() > 0 {
                self.searchBar.placeholder = "Numbers of Articles " + String(self.feedModelView.getElementsCount())
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
        self.searchBar.placeholder = "Numbers of Articles " + "0"
        self.reloadView()
    }
    
    // MARK: - Thumbnail Interaction Delegate
    func thumbnailTouched(_ model: FeedDetailModelView) {
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
  
    func reloadView() {
        self.searchBar.placeholder = "Numbers of Articles " + String(self.feedModelView.getElementsCount())
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
        self.feedModelView.searchText = searchText
        self.reloadView()
    }
    

}
