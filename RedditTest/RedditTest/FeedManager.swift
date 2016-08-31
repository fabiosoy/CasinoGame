//
//  CustomFetchedResultsController.swift
//  Test
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import CoreData

class FeedManager : NSObject {
    
    static let sharedInstance = FeedManager()
    
    //MARK: - Private Properties

    private var coreDataManager = CoreDataManager()
    
    private var requestSended = false
    
    private var completionHandler : ((NSError?, [Feed])->())?
    
    //MARK: - Feed Manager Methods

    func getStoredFeed() -> Array<Feed> {
        return coreDataManager.getAllData()
    }
    
    func getFeed(completionHandler : ((NSError?, [Feed])->())?)  {
       
        let qosClass = QOS_CLASS_DEFAULT
        let backgroundQueue = dispatch_get_global_queue(qosClass, 0)
        dispatch_async(backgroundQueue, {
            guard ConnectionManager.isConnectedToNetwork() else {
                if let completionHandler = completionHandler {
                    completionHandler(nil,self.coreDataManager.getAllData())
                }
                return
            }
            self.completionHandler = completionHandler
            if self.requestSended {
                return
            } else {
                self.requestSended = true
            }
            
            ConnectionManager.sharedInstance.getDataFromServer { [weak self] ( error : NSError?, list : [AnyObject]) in
                if let selfInstance = self {
                    selfInstance.requestSended = false
                    selfInstance.persitData(list)
                    if let completionHandler = completionHandler {
                        completionHandler(error,selfInstance.coreDataManager.getAllData())
                    }
                }
            }
        })
    
}
    
    func deleteAllData()  {
        ConnectionManager.sharedInstance.resetTokens()
        coreDataManager.deleteAllData()
    }
    
    
    private func persitData(list : [AnyObject])  {
        for element in list {
            if let element = element as? Dictionary<String,AnyObject> {
                coreDataManager.insertNewObject(element)
            }
        }
    }
    
}