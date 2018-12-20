// 
//  UIViewController+Swizzling.swift
//  EachNavigationBar
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/11/22
//  Copyright © 2018年 Pircate. All rights reserved.
//

infix operator <=>

private func <=>(left: Selector, right: Selector) {
    if let originalMethod = class_getInstanceMethod(UIViewController.self, left),
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, right) {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension UIViewController {
    
    @available(swift, obsoleted: 4.2, message: "Only for Objective-C call.")
    @objc public static func each_methodSwizzling() {
        methodSwizzling
    }
    
    private static let methodSwizzling: Void = {
        #selector(viewDidLoad) <=> #selector(each_viewDidLoad)
        #selector(viewWillAppear(_:)) <=> #selector(each_viewWillAppear(_:))
        #selector(setNeedsStatusBarAppearanceUpdate)
            <=> #selector(each_setNeedsStatusBarAppearanceUpdate)
    }()
    
    @objc private func each_viewDidLoad() {
        each_viewDidLoad()
        
        guard let navigationController = navigationController,
            navigationController.navigation.configuration.isEnabled else { return }
        
        setupNavigationBarWhenViewDidLoad()
        
        if let tableViewController = self as? UITableViewController {
            tableViewController.addObserverForContentOffset()
        }
    }
    
    @objc private func each_viewWillAppear(_ animated: Bool) {
        each_viewWillAppear(animated)
        
        guard let navigationController = navigationController,
            navigationController.navigation.configuration.isEnabled else { return }
        
        updateNavigationBarWhenViewWillAppear()
    }
    
    @objc private func each_setNeedsStatusBarAppearanceUpdate() {
        each_setNeedsStatusBarAppearanceUpdate()
        
        adjustsNavigationBarPosition()
    }
}
