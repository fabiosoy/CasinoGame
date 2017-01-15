//
//  Feed.swift
//  Test
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation
import CoreData


class Feed: NSManagedObject {
    func intiWithDictionary(_ dictionary : Dictionary<String,AnyObject>) {
        if let tittle = dictionary["title"] as? String { self.tittle = tittle }
        if let thumbnail = dictionary["thumbnail"] as? String { self.thumbnailUrl = thumbnail }
        if let author = dictionary["author"] as? String { self.author = author }
        if let num_comments = dictionary["num_comments"] as? Int { self.num_comments = num_comments as NSNumber? }
        if let seconds = dictionary["created_utc"] as? Int { self.date = Date(timeIntervalSince1970:Double(seconds))}
        if let id = dictionary["id"] as? String { self.id = id }
        self.time = Date()
        if let preview = dictionary["preview"] as? Dictionary<String,Array<Dictionary<String,AnyObject>>> {
            if let images = preview["images"]{
                if images.count > 0 {
                    let image = images[images.count-1]
                    print(image)
                    if let source = image["source"] as? Dictionary<String,AnyObject> {
                        if let imageUrl = source["url"] as? String {
                            self.imageFullUrl = imageUrl
                        }
                    }
                }
            }
        }
    }
}
