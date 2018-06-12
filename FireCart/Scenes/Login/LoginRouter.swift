//
//  LoginRouter.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import UIKit

class LoginRouter: LoginPresenterToRouterProtocol {
    
    weak var viewController: LoginViewController?
    
    // MARK: - Navigation
    
    func navigateToRegisterScene() {
        if let vc = Storyboard.Register.instanstiateController(RegisterViewController.self) {
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

