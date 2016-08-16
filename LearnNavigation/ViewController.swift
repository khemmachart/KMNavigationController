//
//  ViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/8/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var navBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: KMNavigationBar!
    
    var isNavBarAnimating: Bool = false
    var isReachedTopEdge: Bool = false
    
    var lastOffset:CGPoint? = CGPointMake(0, 0)
    var lastOffsetCapture:NSTimeInterval? = 0
    
    var isScrollDown: Bool = false
    var isScrollingFast: Bool = false
    
    var isScrollUp: Bool = false
    var isHidden: Bool = false
    
    override func viewDidLoad() {
        
    }
    
    func layoutIfNeededWithAnimation() {
        self.isNavBarAnimating = true
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.isNavBarAnimating = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.detectVelocity(scrollView.contentOffset)
        self.detectReachingTopEdge(scrollView.contentOffset)
        self.detectScrollingDirection(scrollView.contentOffset)
        self.adjustNavigationBarTopConstriant(scrollView.contentOffset)
    }
    
    func detectReachingTopEdge(currentOffset: CGPoint) {
        self.isReachedTopEdge = currentOffset.y <= 0
    }
    
    func detectScrollingDirection(currentOffset: CGPoint) {
        self.isScrollUp = self.lastOffset?.y > currentOffset.y
        self.isScrollDown = self.lastOffset?.y < currentOffset.y
    }
    
    func detectVelocity(currentOffset: CGPoint) {
        let currentTime = NSDate().timeIntervalSinceReferenceDate
        let timeDiff = currentTime - lastOffsetCapture!
        let captureInterval = 0.1
        
        if(timeDiff > captureInterval) {
            let distance = currentOffset.y - lastOffset!.y     // calc distance
            let scrollSpeedNotAbs = (distance * 10) / 1000     // pixels per ms*10
            let scrollSpeed = fabsf(Float(scrollSpeedNotAbs))  // absolute value
    
            self.isScrollingFast = scrollSpeed > 1.25 ? true : false
            // self.isScrollingFast ? print("Fast") : print("Slow")
            self.lastOffset = currentOffset
            self.lastOffsetCapture = currentTime
        }
    }
    
    func adjustNavigationBarTopConstriant(currentOffset: CGPoint) {

        if (self.isNavBarAnimating) {
            return
        }
        
        let isFastScrollUp   = self.isScrollUp && self.isScrollingFast
        let shouldHideNavBar = !self.isHidden && self.isScrollDown && !self.isReachedTopEdge
        let shouldShowNavBar = self.isHidden && self.isReachedTopEdge || isFastScrollUp
        
        if (shouldHideNavBar) {
            let topConstraint = CGFloat(-88.0)
            self.navBarTopConstraint.constant = topConstraint
            self.isHidden = true
            self.layoutIfNeededWithAnimation()
        }
        else if (shouldShowNavBar) {
            self.navBarTopConstraint.constant = 0
            self.isHidden = false
            self.layoutIfNeededWithAnimation()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

