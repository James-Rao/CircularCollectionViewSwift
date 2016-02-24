//
//  Math.swift
//  CircularCollectionViewSwift
//
//  Created by James Rao on 24/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit


class Math {
    
    class func distanceBetween(point1: CGPoint, point2: CGPoint) -> CGFloat {
        
        let dx = point2.x - point1.x;
        let dy = point2.y - point1.y;
        return sqrt(dx*dx + dy*dy);
    }
    
    
    class func degreesToRadians (degrees: CGFloat) -> CGFloat {
    
        return degrees * CGFloat(M_PI) / 180
    }
    
    
    class func radiansToDegrees(radians: CGFloat) -> CGFloat {
        
        return radians * 180 / CGFloat(M_PI)
    }
}