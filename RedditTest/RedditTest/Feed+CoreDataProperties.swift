//
//  Feed+CoreDataProperties.swift
//  Test
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Feed {

    @NSManaged var tittle: String?
    @NSManaged var author: String?
    @NSManaged var date: Date?
    @NSManaged var thumbnailUrl: String?
    @NSManaged var thumbnailData : Data?
    @NSManaged var num_comments: NSNumber?
    @NSManaged var imageFullUrl: String?
    @NSManaged var imageFullData : Data?
    @NSManaged var id: String?
    @NSManaged var time : Date?

}
