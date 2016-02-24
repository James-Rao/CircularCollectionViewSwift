//
//  ViewController.swift
//  CircularCollectionViewSwift
//
//  Created by James Rao on 24/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    let _numberOfItemsPerSection = 10
    let _numberOfSections = 4
    let _sectionItemStr = "item"
    let _collectionViewCellIdentifier = "cvCell"
    var _items: NSArray?
    let _colors = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self._collectionView.delegate = self;
//        self._collectionView.dataSource = self;
//        self.setup()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        self._collectionView.delegate = self;
        self._collectionView.dataSource = self;
        self.setup()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("section \(section) count is \(self._items?.objectAtIndex(section).count)")
        return (self._items?.objectAtIndex(section).count)!
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        print("items count is \(self._items!.count)")
        return (self._items?.count)!
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self._collectionViewCellIdentifier, forIndexPath: indexPath) as! LabelCollectionViewCell
        
        // give each some colour
        let color = self._colors.objectAtIndex(indexPath.section)
        let current = indexPath.row + 1
        let total = collectionView.numberOfItemsInSection(indexPath.section)
        let cellAlpha = CGFloat(CGFloat(current) / CGFloat(total))
        cell.backgroundColor = color.colorWithAlphaComponent(cellAlpha)
        
        // center one
//        if (indexPath.item == 0 && indexPath.section == 0) {
//            var newFrame = cell.frame
//            newFrame.origin = CGPoint(x: cell.frame.origin.x - 10, y: cell.frame.origin.y - 10)
//            newFrame.size = CGSize(width: cell.frame.size.width + 20, height: cell.frame.size.height + 20)
//            cell.frame = newFrame;
//        }
        
        // index each
        let text = String(format: "%d|%d", indexPath.section, indexPath.row)
        cell.indexLabel.text = text
        
        // style
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius  = cell.bounds.size.width / 2.0
        cell.layer.shouldRasterize = true
        cell.layer.opaque = true
        
        // animation
        let finalBounds = cell.bounds
        cell.bounds.size = CGSizeZero
        UIView.animateWithDuration(3, animations: {
            cell.bounds = finalBounds
        })
        
        return cell
    }


    private func randomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
    func setup() {
        
        let array = NSMutableArray()
        
        // set center section
        let section0 = NSMutableArray()
        self._colors.addObject(randomColor())
        section0.addObject(self._sectionItemStr)
        array.addObject(section0)
        
        // other sections
        for var sectionCount = 1; sectionCount < self._numberOfSections; sectionCount++ {
            
            let section = NSMutableArray()
            self._colors.addObject(randomColor())
            
            for var itemCount = 0; itemCount < self._numberOfItemsPerSection * sectionCount; itemCount++ {
                section.addObject(self._sectionItemStr)
            }
            
            array.addObject(section)
        }
        
        self._items = NSArray(array: array)
        
        _collectionView.backgroundColor = UIColor.clearColor()
        let x = self._collectionView.frame.origin.x + self._collectionView.frame.size.width / 2
        let y = self._collectionView.frame.origin.y + self._collectionView.frame.size.height / 2
        print("center is \(x), \(y)")
        _collectionView.setCollectionViewLayout(CircularCollectionViewLayout(centerPoint: CGPoint(x: x, y: y)), animated: false)
        //_collectionView.setCollectionViewLayout(CircularCollectionViewLayout(), animated: false)
    }

}

