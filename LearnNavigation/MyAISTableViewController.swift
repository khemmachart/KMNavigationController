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
        if let delegate = self.delegate {
            delegate.scrollViewDidScroll(scrollView)
        }
    }
}

extension MyAISTableViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}