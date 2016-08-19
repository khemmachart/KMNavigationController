//
//  MenuLevel1ViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/19/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class MenuLevel1ViewController: KMNavigationController, CAPSPageMenuDelegate {
    
    var titles = ["Home", "Package", "Balance", "Payment", "Transfer"]
    var pageMenu: CAPSPageMenu!
    
    override func viewDidLoad() {
        self.initPageMenu()
        self.stickBackgrounImageView = false
        self.navigationBar.updateCurrentMenuLabel(titles[0])
        self.navigationBar.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
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
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        self.showNavigaiton(animation: true)
    }
    
    func willMoveToPage(controller: UIViewController, index: Int){
        self.navigationBar.updateCurrentMenuLabel(titles[index])
    }
    
    func getSubControllersFor(titles: [String], delegate: UIViewController) -> [UIViewController] {
        
        var controllers: [UIViewController] = []
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for (index, element) in titles.enumerate()  {
            let viewId = (index%2 == 0) ? "MyAISTableViewController" : "MyAISViewController"
            let viewController = storyboard.instantiateViewControllerWithIdentifier(viewId) as! MyAISTableViewController
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
}
