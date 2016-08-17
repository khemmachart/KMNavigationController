//
//  ViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/8/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class KMNavigationController: UIViewController, UIScrollViewDelegate, CAPSPageMenuDelegate {
    
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
    
    var scrollSpeedRate: Float = 1.0
    
    var isScrollDown: Bool = false
    var isScrollingFast: Bool = false
    var isScrollUp: Bool = false
    
    var titles = ["Home", "Package", "Balance", "Payment", "Transfer"]
    var pageMenu: CAPSPageMenu!
    
    override func viewDidLoad() {
        self.stickBackgrounImageView = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.initPageMenu()
        self.navigationBar.updateCurrentMenuLabel(titles[0])
    }
    
    func initPageMenu() {
        let controllerArray = self.getSubControllersFor(titles, delegate: self)
        let parameters: [CAPSPageMenuOption] = [
            // .UseMenuLikeSegmentedControl(false),
            .AddBottomMenuHairline(true),
            .EnableHorizontalBounce(false),
            
            .MenuItemFont(UIFont.systemFontOfSize(12)),
            .BottomMenuHairlineColor(UIColor.lightGrayColor()),
            .UnselectedMenuItemLabelColor(UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            
            .MenuHeight(35.0),
            .SelectionIndicatorHeight(3.0),
            .MenuItemSeparatorPercentageHeight(0.0),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                    frame: self.getPageMenuContainerFrame(),
                                    pageMenuOptions: parameters)
        pageMenu.delegate = self
        
        self.contentView.addSubview(pageMenu.view)
    }
    
    func willMoveToPage(controller: UIViewController, index: Int){
        self.navigationBar.updateCurrentMenuLabel(titles[index])
    }
    
    func getSubControllersFor(titles: [String], delegate: UIViewController) -> [UIViewController] {
        
        var controllers: [UIViewController] = []
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for (index, element) in titles.enumerate()  {
            let viewController = storyboard.instantiateViewControllerWithIdentifier("MyAISTableViewController") as! MyAISTableViewController
            viewController.title = element
            viewController.delegate = self
            viewController.view.backgroundColor = (index%2==0) ? UIColor.redColor() : UIColor.blueColor()
            controllers.append(viewController)
        }
        
        return controllers
    }
    
    func getPageMenuContainerFrame() -> CGRect {
        let width  = self.contentView.frame.width
        let height = self.contentView.frame.height
        return CGRectMake(0, 0, width, height)
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
    
            self.isScrollingFast = scrollSpeed > self.scrollSpeedRate ? true : false
            // self.isScrollingFast ? print("Fast") : print("Slow")
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
            self.navBarTopConstraint.constant = self.calculateNavigationBarTopConstraintAfterHidden()
            self.navigationBar.hidden(true, withAnimation: true)
            self.layoutIfNeededWithAnimation()
            
        }
        else if (shouldShowNavBar && self.navigationBar.isHiddenBar) {
            self.navBarTopConstraint.constant = 0
            self.navigationBar.hidden(false, withAnimation: true)
            self.layoutIfNeededWithAnimation()
        }
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
