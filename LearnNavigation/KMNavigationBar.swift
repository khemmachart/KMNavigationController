//
//  CustomView.swift
//  CustomViewFromXib
//
//  Created by Paul Solt on 12/10/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

@IBDesignable class KMNavigationBar: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBInspectable var image: UIImage? {
        get {
            return backgroundImageView.image
        }
        set(image) {
            backgroundImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupInterface()
    }
    
    func setupInterface() {
        self.setupXib()
        self.setupNavigationBar()
    }
    
    func setupXib() {
        self.view = loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let className = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".")[1]
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: className, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setupNavigationBar() {
        let leftButton   = UIBarButtonItem(title: "E", style: .Plain, target: self, action: nil)
        let rightButton1 = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: nil)
        let rightButton2 = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: nil)
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItems = [rightButton1, rightButton2]
        navigationItem.leftBarButtonItem = leftButton
        
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.setItems([navigationItem], animated: false)
        
        UINavigationBar.appearance().titleTextAttributes = [
            // NSFontAttributeName : UIFont.appNavBarTitle(),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            // NSFontAttributeName: UIFont.appNavBarButton(),
            NSForegroundColorAttributeName: UIColor.whiteColor()],
                                                            forState: UIControlState.Normal)
    }
}
