//
//  MainConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 25.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class MainConfigurator {
    
    class func configure(viewController: MainViewController) {
        
        let router = MainRouter()
        let interactor = MainInteractor()
        let presenter = MainPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
