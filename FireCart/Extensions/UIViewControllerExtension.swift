//
//  UIViewControllerExtension.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiateControllerFrom(storyboard : String) -> UIViewController? {
        let viewControllerIdentifier = String(describing:self)
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        
        return viewController
    }
    
    func addViewControllerFillBounds(containedViewController: UIViewController, in containerView: UIView) {
        addChildViewController(containedViewController)
        containedViewController.view.frame = containerView.bounds
        containerView.addSubview(containedViewController.view)
        containedViewController.didMove(toParentViewController: self)
    }
    
    func removeAllChildViewControllers() {
        childViewControllers.forEach {
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
        }
    }
    
    func removeChildViewController<T>(ofType: T.Type){
        childViewControllers.forEach {
            if type(of: $0) == T.self {
                $0.willMove(toParentViewController: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParentViewController()
            }
        }
    }
    
}
