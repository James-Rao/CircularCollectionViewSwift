//
//  CircularCollectionViewLayout.swift
//  CircularCollectionViewSwift
//
//  Created by James Rao on 24/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    let _cellHeight:CGFloat = 40.0
    let _cellWidth:CGFloat = 40.0
    var _centerPoint: CGPoint
    let _cellRotateStyle: CellRotateStyle = .RotateToCenter
    let _distanceFromCenter: CGFloat = 70
    var _points: NSArray?

    init(centerPoint: CGPoint) {
        
        self._centerPoint = centerPoint
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        self._centerPoint = CGPoint(x: 0, y: 0)
        super.init(coder: aDecoder)
    }
    
   
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let array = NSMutableArray()
        for var sectionCount = 0; sectionCount < self.collectionView?.numberOfSections(); sectionCount++ {
            let sectionArray = NSMutableArray()
            let currentDistanceFromCenter = _distanceFromCenter * CGFloat(sectionCount)
            let numberOfItems = self.collectionView?.numberOfItemsInSection(sectionCount)
            if numberOfItems == 0 {
                return
            }
            let angle = 360 / numberOfItems!
            for var currentAngle = 0; currentAngle < 360; currentAngle += angle {
                let x = currentDistanceFromCenter * cos(Math.degreesToRadians(CGFloat(currentAngle))) + self._centerPoint.x
                let y = currentDistanceFromCenter * sin(Math.degreesToRadians(CGFloat(currentAngle))) + self._centerPoint.y
                sectionArray.addObject(PointObj(x: x, y: y))
            }
            array.addObject(sectionArray)
        }
        _points = array
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let point = self._points?.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row)
        attributes.size = CGSize(width: _cellWidth, height: _cellHeight)
        attributes.center = CGPoint(x: (point?.x)!, y: (point?.y)!)
        if self._cellRotateStyle == CellRotateStyle.RotateToCenter {
            let rotation = self.rotationForAttributes(attributes, indexPath: indexPath)
            attributes.transform = CGAffineTransformMakeRotation(Math.degreesToRadians(rotation))
        }
//        print("attributes size is \(attributes.size)")
//        print("attributes center is \(attributes.center)")
        return attributes
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes: [UICollectionViewLayoutAttributes] = []
        for var sectionCount = 0; sectionCount < self.collectionView!.numberOfSections(); sectionCount++ {
            for var itemCount = 0; itemCount < self.collectionView!.numberOfItemsInSection(sectionCount); itemCount++ {
                let indexPath = NSIndexPath(forItem: itemCount, inSection: sectionCount)
                attributes.append(self.layoutAttributesForItemAtIndexPath(indexPath)!)
            }
        }
        
        return attributes
    }
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
    func rotationForAttributes(attributes: UICollectionViewLayoutAttributes, indexPath: NSIndexPath) -> CGFloat {
    
        let pointA = self._centerPoint;
        let pointC = (_points?.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! PointObj).Point
        let pointB = CGPoint(x: pointA.x, y: pointC.y)
        
        var angleC: CGFloat = 0
        
        let a = Math.distanceBetween(pointC, point2: pointB)
        let b = Math.distanceBetween(pointA, point2: pointC)
        let c = Math.distanceBetween(pointA, point2: pointB)
        
        let a2 = pow(a, 2)
        let b2 = pow(b, 2)
        let c2 = pow(c, 2)
        let ab2 = 2 * a * b
        
        var val = (a2 + b2 - c2)/ab2
        val = ab2 == 0 ? 0 : val;
        
        let acosVal = acos(val)
        angleC = Math.radiansToDegrees(acosVal)
        
        var answer: CGFloat = 0
        if (pointC.y + attributes.size.height/2 < self._centerPoint.y) {
            
            // top left
            if (pointC.x + attributes.size.width/2 < self._centerPoint.x) {
                answer = angleC - 90;
            }
                // top right
            else {
                answer = 90 - angleC;
            }
        } else {
            // bottom left
            if (pointC.x + attributes.size.width/2 < self._centerPoint.x) {
                answer = 270 - angleC;
            }
                // bottom right
            else {
                answer = angleC - 270;
            }
        }

        return answer;
    }

    
    override func collectionViewContentSize() -> CGSize {
        return (self.collectionView?.bounds.size)!
    }
}

