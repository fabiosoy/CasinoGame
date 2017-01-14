//
//  NSDate.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation


extension Date {

    func timeAgoSinceDate() -> String {
        let calendar = Calendar.current
        let now = Date()
        var earliest = now
        if self.timeIntervalSince1970 < earliest.timeIntervalSince1970 {
            earliest = self
        }
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        guard let year = components.year, let month = components.month, let weekOfYear = components.weekOfYear,let day = components.day,let hour = components.hour,let minute = components.minute, let second = components.second else {
            return ""
        }
        if (year >= 2) {
            return String(describing: components.year) + " years ago"
        } else if (year >= 1){
            return "Last year"
        } else if (month >= 2) {
            return String(month) + " months ago"
        } else if (month >= 1){
            return "Last month"
        } else if (weekOfYear >= 2) {
            return String(weekOfYear) + " weeks ago"
        } else if (weekOfYear >= 1){
            return "Last week"
        } else if (day >= 2) {
            return String(day) + " days ago"
        } else if (day >= 1){
            return "Yesterday"
        } else if (hour >= 2) {
            return String(hour)  + " hours ago"
        } else if (hour >= 1){
            return "An hour ago"
        } else if (minute >= 2) {
            return String(minute) + " minutes ago"
        } else if (minute >= 1){
            return "A minute ago"
        } else if (second >= 3) {
            return String(second) + " seconds ago"
        } else {
            return "Just now"
        }
        
    }

}
