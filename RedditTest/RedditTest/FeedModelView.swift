//
//  FeedModelView.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 13/01/17.
//  Copyright © 2017 Fabio Bermudez. All rights reserved.
//

import Foundation
import UIKit

enum RequestDataErrors: Error {
    case noConnection
    case isLoading
    case maxItemsReached
    case inSearchMode

}


class FeedModelView {
    //MARK: - Private Properties

    private var dataList = Array<FeedItemModelView>()
    private var fullDataList = Array<FeedItemModelView>()
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
                dataList = Array<FeedItemModelView>(filteredArray)
            } else {
                dataList = Array<FeedItemModelView>(fullDataList)
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

    func requestData(reload : Bool,callBack : (()->())? ) throws {
        guard ConnectionManager.isConnectedToNetwork() else {
            throw RequestDataErrors.noConnection
        }
        guard loadingData == false else {
            throw RequestDataErrors.isLoading
        }
        guard searchText.characters.count == 0 else {
            throw RequestDataErrors.inSearchMode
        }
        if reload == false {
            guard fullDataList.count < Config.max_items  else {
                throw RequestDataErrors.maxItemsReached
            }
        }
        self.updateViewCallBack = callBack
        if reload {
            feedManager.deleteAllData()
            fullDataList.removeAll()
            dataList.removeAll()
        }
        self.requestData()
    }
    
    func getElementsCount() -> Int {
        return dataList.count
    }
    
    func getElementForRow(row : Int) ->  FeedItemModelView {
        return dataList[row]
    }
    
    //MARK: - Private Methods

    private func proccesListModel(list : Array<Feed>) {
        for feed in list {
            let feedItemModelView = FeedItemModelView(newFeed:feed)
            fullDataList.append(feedItemModelView)
            dataList.append(feedItemModelView)
        }
    }
    
    private func loadStoredFeed() {
        self.proccesListModel(list: feedManager.getStoredFeed())
    }
    
    private func requestData()  {
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
