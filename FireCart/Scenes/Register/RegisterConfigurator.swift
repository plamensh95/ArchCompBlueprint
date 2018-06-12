//
//  RegisterConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class RegisterConfigurator {
    
    class func configure(viewController: RegisterViewController) {
        
        let router = RegisterRouter()
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
