//
//  PointObj.swift
//  CircularCollectionViewSwift
//
//  Created by James Rao on 24/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit


class PointObj : NSObject {
    
    let x: CGFloat
    let y: CGFloat
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    var Point: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}