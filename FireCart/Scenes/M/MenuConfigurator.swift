//
//  MenuConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class MenuConfigurator {
    
    class func configure(viewController: MenuViewController) {
        
        let router = MenuRouter()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
