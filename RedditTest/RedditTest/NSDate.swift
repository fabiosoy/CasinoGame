//
//  NSDate.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation


extension NSDate {

    func timeAgoSinceDate() -> String {
    
                let now = NSDate()
        let earliest = NSDate().earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:NSDateComponents =  NSCalendar.currentCalendar().components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        if (components.year >= 2) {
            return  String(format: "%d years ago", components.year)
        } else if (components.year >= 1){
           return "Last year"
        } else if (components.month >= 2) {
            return String(format: "%d months ago", components.month)
        } else if (components.month >= 1){
            return "Last month"
        } else if (components.weekOfYear >= 2) {
            return String(format: "%d weeks ago", components.weekOfYear)
        } else if (components.weekOfYear >= 1){
            return "Last week"
        } else if (components.day >= 2) {
            return String(format: "%d days ago", components.day)
        } else if (components.day >= 1){
            return "Yesterday"
        } else if (components.hour >= 2) {
            return String(format: "%d hours ago", components.hour)
        } else if (components.hour >= 1){
            return "An hour ago"
        } else if (components.minute >= 2) {
            return String(format: "%d minutes ago", components.minute)
        } else if (components.minute >= 1){
            return "A minute ago"
        } else if (components.second >= 3) {
            return String(format: "%d seconds ago", components.second)
        } else {
            return "Just now"
        }
        
    }

}