//
//  MainRouter.swift
//  FireCart
//
//  Created by Plamen Iliev on 25.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class MainRouter: MainPresenterToRouterProtocol {

    weak var viewController: MainViewController?
    
    // MARK: - Navigation
    func navigateToLoginScene() {
        guard let _ = viewController?.navigationController?.popToController(name: LoginViewController.self, type: LoginViewController.self) else {
            if let vc = Storyboard.Login.instanstiateController(LoginViewController.self) {
                viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
    }
    
}

