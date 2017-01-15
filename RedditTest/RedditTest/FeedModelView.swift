//
//  FeedModelView.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 13/01/17.
//  Copyright © 2017 Fabio Bermudez. All rights reserved.
//

import Foundation
import UIKit


class FeedModelView {
    //MARK: - Private Properties

    private var dataList = Array<FeedDetailModelView>()
    private var fullDataList = Array<FeedDetailModelView>()
    private let feedManager = FeedManager.sharedInstance
    private var loadingData = false
    private var privateSearchText = ""
    private var updateViewCallBack : (()->())?
    
    //MARK: - Public Properties
    
    var searchText : String {
        set{
            privateSearchText = newValue
            if newValue.characters.count > 0 {
                let filteredArray = fullDataList.filter() { $0.tittle?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil }
                dataList = Array<FeedDetailModelView>(filteredArray)
            } else {
                dataList = Array<FeedDetailModelView>(fullDataList)
            }
        }
        get{
            return privateSearchText
        }
    }
    
    var numbersOfArticlesText : String {
        get {
            return "Numbers of Articles " + String(dataList.count)
        }
    }
    
    //MARK: - Init

    init() {
        searchText = ""
        self.loadStoredFeed()
    }
    
    //MARK: - Methods

    func requestData(reload : Bool,callBack : (()->())? ) -> Bool {
        guard (loadingData == false &&
            fullDataList.count < Config.max_items &&
            searchText.characters.count == 0 ) || reload == true else {
                return false
        }
        self.updateViewCallBack = callBack
        if reload {
            feedManager.deleteAllData()
            fullDataList.removeAll()
            dataList.removeAll()
        }
        self.requestData()
        return true
    }
    
    func getElementsCount() -> Int {
        return dataList.count
    }
    
    func getElementForRow(row : Int) ->  FeedDetailModelView {
        return dataList[row]
    }
    
    //MARK: - Private Methods

    fileprivate func proccesListModel(list : Array<Feed>) {
        for feed in list {
            let feedDetailModelView = FeedDetailModelView(newFeed:feed)
            fullDataList.append(feedDetailModelView)
            dataList.append(feedDetailModelView)
        }
    }
    
    fileprivate func loadStoredFeed() {
        self.proccesListModel(list: feedManager.getStoredFeed())
    }
    
    fileprivate func requestData()  {
        loadingData = true
        feedManager.getFeed { [weak self](error : Error?, list : [Feed]) in
            guard error == nil else {
                return
            }
            if let selfInstance = self {
                if list.count > 0 {
                    selfInstance.fullDataList.removeAll()
                    selfInstance.dataList.removeAll()
                    self?.proccesListModel(list: list)
                }
                selfInstance.loadingData = false
                if let callBack = selfInstance.updateViewCallBack {
                    callBack()
                }
            }
        }
    }
    

    
}
