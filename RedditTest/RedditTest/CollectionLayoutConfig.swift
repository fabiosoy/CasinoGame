//
//  CollectionLayoutConfig.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation
import UIKit

// Collection Layout Configs
struct CollectionLayoutConfig {
    static let NUMBER_CELL_ROWS : CGFloat = 2
    static let CELL_MARGIN : CGFloat = 2
    static let CELL_WIDTH : CGFloat = CGFloat( CGFloat(ScreenSize.width) / CollectionLayoutConfig.NUMBER_CELL_ROWS) - CollectionLayoutConfig.CELL_MARGIN
    static let CELL_MIN_HEIGHT : CGFloat = 205
    static let TEXT_MAX_HEIGHT : CGFloat = 5000
    static let FONT_SIZE : CGFloat = 15.0

}