//
//  Navigator.swift
//  Storyboarding
//
//  Created by Damyan Todorov on 10/23/17.
//  Copyright © 2017 FlatRockTechnology. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func popToController<T>(name : AnyClass, type: T.Type) -> T? {
        for controller in self.viewControllers.reversed() {
            if controller.isKind(of: name) {
                self.popToViewController(controller, animated: true)
                return controller as? T
            }
        }
        return nil
    }
    static func instantiateLikeRoot (vc : UIViewController) {
        let navController = UINavigationController.init(rootViewController: vc)
        appDelegate.window?.rootViewController = navController
    }
}

enum Storyboard:String {
    
    case Login
    case Register
    case Main
    case Menu
    case Orders
    case Cart
    
    func instanstiateController (_ viewController : UIViewController.Type) -> UIViewController? {
        return viewController.instantiateControllerFrom(storyboard:self.rawValue)
    }
}

enum UserState {
    
    case notLogged
    case logged
    
}

class Navigator {
    
    func provideInitialController() -> UIViewController {
        switch getUserState() {
        case .logged:
            return Storyboard.Main.instanstiateController(MainViewController.self)!
        case .notLogged:
            return Storyboard.Login.instanstiateController(LoginViewController.self)!
        }
        
    }
    
    private func getUserState () -> UserState {
        return FRTAuthenticationService.shared.isUserLogged() ? .logged : .notLogged
    }
 
}

















