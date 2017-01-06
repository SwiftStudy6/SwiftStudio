//
//  CustomNavigationSegue.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 30..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit

class CustomNavigationSegue: UIStoryboardSegue {

    override func perform() {
        
        let tabBarController : CustomTabBarController = self.source as! CustomTabBarController
        let destinationController : UIViewController = self.destination
        
        for view in (tabBarController.placeholderView?.subviews)! {
            view.removeFromSuperview()
        }
        
        // Add view to placeholder view
        tabBarController.currentViewController = destinationController
        tabBarController.placeholderView?.addSubview(destinationController.view)
        
        //Set autorizing
        tabBarController.placeholderView?.translatesAutoresizingMaskIntoConstraints = false
        
        let childview : UIView = destinationController.view
        childview.translatesAutoresizingMaskIntoConstraints = false
        
        //fill horizontal
        tabBarController.placeholderView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childview]|",
                                                                                        options: .alignAllLeft,
                                                                                        metrics: nil,
                                                                                        views: ["childview":childview]))

        
        
        //fill vertical
        tabBarController.placeholderView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[childview]-0-|",
                                                                                        options: .alignAllLeft,
                                                                                        metrics: nil,
                                                                                        views: ["childview":childview]))
        
        tabBarController.placeholderView?.layoutIfNeeded()
        
        //notify did move
        destinationController.didMove(toParentViewController: tabBarController)
        
        
            
    }
}
