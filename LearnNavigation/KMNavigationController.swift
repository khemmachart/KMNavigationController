//
//  ViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/8/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class KMNavigationController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var navBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: KMNavigationBar!
    @IBOutlet weak var contentView: UIView!
    
    var stickBackgrounImageView: Bool = true
    var stickInformationView: Bool = true
    var stickPageMenuView: Bool = true
    
    var showStatusBar: Bool = true
    
    var isNavBarAnimating: Bool = false
    var isReachedTopEdge: Bool = false
    
    var lastOffset: CGPoint? = CGPointMake(0, 0)
    var lastOffsetCapture: NSTimeInterval? = 0
    
    var scrollSpeedRate: Float = 0.85
    
    var isScrollDown: Bool = false
    var isScrollingFast: Bool = false
    var isScrollUp: Bool = false
    
    override func viewDidLoad() {
        self.navigationBar.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
    }
        
    func layoutIfNeeded(animation animation: Bool) {
        let duration = animation ? 0.25 : 0.025
        self.isNavBarAnimating = true
        UIView.animateWithDuration(duration, animations: {
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
        
        if (timeDiff > captureInterval) {
            let distance = currentOffset.y - lastOffset!.y     // calc distance
            let scrollSpeedNotAbs = (distance * 10) / 1000     // pixels per ms*10
            let scrollSpeed = fabsf(Float(scrollSpeedNotAbs))  // absolute value
    
            self.isScrollingFast = scrollSpeed > self.scrollSpeedRate ? true : false
            self.lastOffset = currentOffset
            self.lastOffsetCapture = currentTime
        }
    }
    
    func adjustNavigationBarTopConstriant(currentOffset: CGPoint) {

        if (self.stickBackgrounImageView) {
            return
        }
        if (self.isNavBarAnimating) {
            return
        }
        
        let isFastScrollUp   = self.isScrollUp && self.isScrollingFast
        let shouldHideNavBar = self.isScrollDown && !self.isReachedTopEdge
        let shouldShowNavBar = self.isReachedTopEdge || isFastScrollUp
        
        if (shouldHideNavBar && !self.navigationBar.isHiddenBar) {
            self.hideNavigation(animation: true)
        }
        else if (shouldShowNavBar && self.navigationBar.isHiddenBar) {
            self.showNavigaiton(animation: true)
        }
    }
    
    func hideNavigation(animation animation: Bool) {
        let navBarTopConstraint = self.calculateNavigationBarTopConstraintAfterHidden()
        self.navBarTopConstraint.constant = navBarTopConstraint
        self.navigationBar.hidden(true, withAnimation: true, withNavBarTopConstraint: navBarTopConstraint)
        self.layoutIfNeeded(animation: animation)
    }
    
    func showNavigaiton(animation animation: Bool) {
        self.navBarTopConstraint.constant = 0
        self.navigationBar.hidden(false, withAnimation: true, withNavBarTopConstraint: 0)
        self.layoutIfNeeded(animation: animation)
    }
    
    func calculateNavigationBarTopConstraintAfterHidden() -> CGFloat {
        
        var hiddenConstraint: CGFloat = 0
        
        if (self.prefersStatusBarHidden()) {
            hiddenConstraint += 20
        }
        
        if (!self.stickBackgrounImageView) {
            hiddenConstraint += 88
            if (!self.stickInformationView && self.prefersStatusBarHidden()) {
                hiddenConstraint += 44
                if (!self.stickPageMenuView) {
                    hiddenConstraint += 33
                }
            }
        }
        
        return -hiddenConstraint
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return !self.showStatusBar
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension KMNavigationController: KMNavigationBarDelegate {
    
}