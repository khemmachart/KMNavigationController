//
//  CustomView.swift
//  CustomViewFromXib
//
//  Created by Paul Solt on 12/10/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

protocol KMNavigationBarDelegate: class {
    var showStatusBar: Bool {get set}
}

@IBDesignable class KMNavigationBar: UIView {
    
    var _delegate: KMNavigationBarDelegate?
    var delegate: KMNavigationBarDelegate? {
        get {
            return _delegate
        }
        set {
            self._delegate = newValue
            self.setupInterface()
        }
    }
    
    var view: UIView!
    var isHiddenBar: Bool = false
    
    @IBOutlet weak var statusBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarOverlayHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusBarOverlayView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var currentMenuTitleLabel: UILabel!
    
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
        self.setStatusBarOverlayView()
    }
    
    func setupXib() {
        if (self.view == nil) {
            self.view = loadViewFromNib()
            self.view.frame = bounds
            self.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.addSubview(self.view)
        }
    }
    
    func loadViewFromNib() -> UIView {
        let className = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".")[1]
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: className, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setStatusBarOverlayView() {
        if let delegate = self.delegate {
            let statusBarHeight: CGFloat = delegate.showStatusBar ? 20 : 0
            self.statusBarOverlayHeightConstraint.constant = statusBarHeight
            self.navigationBarTopConstraint.constant = statusBarHeight
        }
    }
    
    func setupNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().titleTextAttributes = [
            // NSFontAttributeName : UIFont.appNavBarTitle(),
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            // NSFontAttributeName: UIFont.appNavBarButton(),
            NSForegroundColorAttributeName: UIColor.whiteColor()],
                                                            forState: UIControlState.Normal)
    }
    
    func updateCurrentMenuLabel(title: String) {
        self.currentMenuTitleLabel.text = title
    }
    
    func hidden(isHidden: Bool, withAnimation animation: Bool, withNavBarTopConstraint navBarTopConstraint: CGFloat) {
        self.isHiddenBar = isHidden
        if (animation) {
            self.animateViewWhenHidden(isHidden, withNavBarTopConstraint: navBarTopConstraint)
        }
    }
    
    func animateViewWhenHidden(isHidden: Bool, withNavBarTopConstraint navBarTopConstraint: CGFloat) {
        UIView.animateWithDuration(0.25, animations: {
            self.currentMenuTitleLabel.alpha = isHidden ? 0 : 1
            self.statusBarTopConstraint.constant = isHidden ? -navBarTopConstraint : 0
        })
    }
}
