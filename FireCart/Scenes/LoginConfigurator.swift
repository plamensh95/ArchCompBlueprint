//
//  LoginConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class LoginConfigurator {
    
    class func configure(viewController: LoginViewController) {
        
        let router = LoginRouter()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
