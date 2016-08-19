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
        self.initNavigationItems()
        self.stickBackgrounImageView = false
        self.navigationBar.updateCurrentMenuLabel(titles[0])
        super.viewDidLoad()
    }
    
    func initNavigationItems() {
        let leftButton   = UIBarButtonItem(title: "E", style: .Plain, target: self, action: nil)
        let rightButton1 = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: nil)
        let rightButton2 = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: nil)
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItems = [rightButton1, rightButton2]
        navigationItem.leftBarButtonItem = leftButton
        self.navigationBar.navigationBar.setItems([navigationItem], animated: false)
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
            let viewId = (index%3 == 0) ? "MyAISViewController" : "MyAISTableViewController"
            let viewController = storyboard.instantiateViewControllerWithIdentifier(viewId) as! BaseViewController
            viewController.title = element
            viewController.myAISNavigationController = self
            viewController.view.backgroundColor = (index%3==0) ? UIColor.blueColor() : UIColor.redColor()
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
