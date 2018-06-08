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
    func popToController (name : AnyClass) {
        for controller in self.viewControllers {
            if controller.isKind(of: name) {
                self.popToViewController(controller, animated: true)
            }
        }
    }
    static func instantiateLikeRoot (vc : UIViewController) {
        let navController = UINavigationController.init(rootViewController: vc)
        appDelegate.window?.rootViewController = navController
    }
}


extension UIViewController {
    static func instantiateControllerFrom(storyboard : String) -> UIViewController? {
        let viewControllerIdentifier = String(describing:self)

        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)

        return viewController
    }
}

enum Storyboard:String {
    
    case Main
    
    func instanstiateController (_ viewController : UIViewController.Type) -> UIViewController? {
        return viewController.instantiateControllerFrom(storyboard:self.rawValue)
    }
}

enum UserState {
    
    case notLogged
    case logged
    case banned
    case waitingRegistrationApproval
    
}

class Navigator {
    
    func provideInitialController () -> UIViewController {
        return Storyboard.Main.instanstiateController(ViewController.self)!
    }
    
    private func getUserState () -> UserState {
        return .notLogged
    }
 
}

















