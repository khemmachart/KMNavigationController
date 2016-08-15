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
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var navBarAnimating = false
    
    override func viewDidLoad() {
        
        let frameWidth = self.view.frame.size.width
        let navBarHeight = self.navigationBar.frame.size.height
        let backgroundFrame = CGRectMake(0, 0, frameWidth, navBarHeight + 44)
        
        let imageView = UIImageView(frame: backgroundFrame)
        imageView.image = UIImage(named: "background.jpg")
        imageView.contentMode = .ScaleAspectFill
        
        // Background
        let backgroundView = UIView(frame: backgroundFrame)
        backgroundView.addSubview(imageView)
        backgroundView.layer.zPosition = -10
        backgroundView.clipsToBounds = true
        
        // Information
        let leftLabel = UILabel(frame: CGRectMake(28, 0, frameWidth, 44))
        leftLabel.textColor = UIColor.whiteColor()
        leftLabel.font = UIFont.systemFontOfSize(13)
        leftLabel.text = "Tomas Urban Timberland"
        
        let rightLabel = UILabel(frame: CGRectMake(-28, 0, frameWidth, 44))
        rightLabel.textColor = UIColor.whiteColor()
        rightLabel.font = UIFont.systemFontOfSize(13)
        rightLabel.text = "082 080 2636"
        rightLabel.textAlignment = .Right
        
        let informationView = UIView(frame: CGRectMake(0, backgroundView.frame.height, frameWidth, 44))
        informationView.backgroundColor = UIColor(red: 141/255, green: 198/266, blue: 63/255, alpha: 1)
        informationView.addSubview(leftLabel)
        informationView.addSubview(rightLabel)
        
        let containerView = UIView(frame: CGRectMake(0, 0, frameWidth, navBarHeight + 88))
        containerView.addSubview(backgroundView)
        containerView.addSubview(informationView)
        
        let rightButton1 = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: nil)
        let rightButton2 = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: nil)
        let navigationItem = UINavigationItem()
        navigationItem.title = "AIS"
        navigationItem.rightBarButtonItems = [rightButton1, rightButton2]
        
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.addSubview(containerView)
        self.navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().titleTextAttributes = [
            // NSFontAttributeName : UIFont.appNavBarTitle(),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            // NSFontAttributeName: UIFont.appNavBarButton(),
            NSForegroundColorAttributeName: UIColor.whiteColor()],
                                                            forState: UIControlState.Normal)
    }
    
    func layoutIfNeededWithAnimation() {
        self.navBarAnimating = true
        UIView.animateWithDuration(0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            self.navBarAnimating = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let isScrollUp = scrollView.contentOffset.y > 0
        self.adjustNavigationBarTopConstriant(isScrollUp)
    }
    
    func adjustNavigationBarTopConstriant(isScrollUp: Bool) {
        
        if (navBarAnimating) {
            return
        }
        
        if (isScrollUp) {
            let topConstraint = -self.navigationBar.frame.height - 44 + 20
            self.navBarTopConstraint.constant = topConstraint
        } else {
            self.navBarTopConstraint.constant = 0
        }
        
        self.layoutIfNeededWithAnimation()
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
        return 30
    }
}

