//
//  CoreDataManager.swift
//  Test
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreDataManager.saveContext), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("RedditTest", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data support
    
    func insertNewObject(json : Dictionary<String,AnyObject>) {
        
        if let id = json["id"] as? String {
            let fetchRequest = NSFetchRequest(entityName: "Feed")
            fetchRequest.predicate = NSPredicate(format: "id == %@",id)
            do {
                let list = try managedObjectContext.executeFetchRequest(fetchRequest)
                if list.count > 0 {
                    return
                }
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        if let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: managedObjectContext) as? Feed {
            newManagedObject.intiWithDictionary(json)
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func deleteObject(object : NSManagedObject?) {
        guard let object = object else {
            return
        }
        managedObjectContext.deleteObject(object)
    }
    
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllData()  {
        for item in getAllData() { self.deleteObject(item) }
        self.saveContext()
    }
    
    func getAllData() -> Array<Feed> {
        let feedFetch = NSFetchRequest(entityName: "Feed")
        feedFetch.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        var list = Array<Feed>()
        do {
            let fetchedFeed = try managedObjectContext.executeFetchRequest(feedFetch) as! [Feed]
            list.appendContentsOf(fetchedFeed)
            if list.count > Config.max_items {
                list = Array<Feed>(list.prefix(Config.max_items))
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return list
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
