//
//  ThumbnailInteractionDelegate.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 30/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import Foundation

@objc protocol ThumbnailInteractionDelegate {
    func thumbnailTouched(model : Feed);
}
