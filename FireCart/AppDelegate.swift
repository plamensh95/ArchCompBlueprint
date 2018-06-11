//
//  AppDelegate.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    var window: UIWindow?
    var navigator = Navigator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FRTAuthenticationService.shared.configureFirebase()
        FRTAuthenticationService.shared.configureProviders(for: application, with: launchOptions)
        IQKeyboardManager.shared.enable = true
        setupWindow()
        UINavigationController.instantiateLikeRoot(vc: navigator.provideInitialController())
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if FRTAuthenticationService.google!.handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:]) {
            return true
        }
        
        if (FRTAuthenticationService.facebook?.application(application, open: url, options: options))! {
            return true
        }
        
        return false
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FRTAuthenticationService.facebook?.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) ?? false
    }

    private func setupWindow () {
        if appDelegate.window == nil {
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            appDelegate.window!.makeKeyAndVisible()
        }
    }
}

