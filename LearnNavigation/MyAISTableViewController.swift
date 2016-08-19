//
//  MyAISTableViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/17/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import UIKit

class MyAISTableViewController: UIViewController {
    
    var delegate: KMNavigationController?
}

extension MyAISTableViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.shouldHideNavigationBar(scrollView: scrollView),
            let delegate = self.delegate {
            delegate.scrollViewDidScroll(scrollView)
        }
    }
    
    // The navigation bar should be hidden only if the content height is higher than frame size
    // If it true, then call the delegate (Navigation Controller) to action to the navigaiton bar
    func shouldHideNavigationBar(scrollView scrollView: UIScrollView) -> Bool {
        let contentHeight = scrollView.contentSize.height
        let frameHeight   = self.view.frame.size.height
        return contentHeight > frameHeight
    }
}

extension MyAISTableViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}