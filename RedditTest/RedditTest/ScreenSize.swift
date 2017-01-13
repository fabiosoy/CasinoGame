//
//  ScreenSize.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static var width : Float {
        get {
            return Float(UIScreen.main.bounds.size.width)
        }
    }
    static var height : Float {
        get {
            return Float(UIScreen.main.bounds.size.height)
        }
    }
}



