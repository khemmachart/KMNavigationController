//
//  MyAISTableViewController.swift
//  LearnNavigation
//
//  Created by Khemmachart Chutapetch on 8/19/2559 BE.
//  Copyright © 2559 Khemmachart Chutapetch. All rights reserved.
//

import Foundation

class MyAISTableViewController1: BaseViewController {
    
}

class MyAISTableViewController2: BaseViewController {
    
    override func viewDidAppear(animated: Bool) {
        self.myAISNavigationController?.showNavigaiton(animation: true)
    }
}