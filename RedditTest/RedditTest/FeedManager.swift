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
    
    private var completionHandler : ((Error?, [Feed])->())?
    
    //MARK: - Feed Manager Methods

    func getStoredFeed() -> Array<Feed> {
        return coreDataManager.getAllData()
    }
    
    func getFeed(_ completionHandler : ((Error?, [Feed])->())?)  {
       
        let qosClass = DispatchQoS.QoSClass.default
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        backgroundQueue.async(execute: {
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
            
            ConnectionManager.sharedInstance.getDataFromServer { [weak self] ( error : Error?, list : [Any]) in
                if let selfInstance = self {
                    selfInstance.requestSended = false
                    selfInstance.persitData(list)
                    if let completionHandler = selfInstance.completionHandler {
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
    
    func saveData()  {
        coreDataManager.saveContext()
    }
    
    private func persitData(_ list : [Any])  {
        for element in list {
            if let element = element as? Dictionary<String,AnyObject> {
                coreDataManager.insertNewObject(element)
            }
        }
    }
    
}
