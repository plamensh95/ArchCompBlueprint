//
//  CartConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class CartConfigurator {
    
    class func configure(viewController: CartViewController) {
        
        let router = CartRouter()
        let interactor = CartInteractor()
        let presenter = CartPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
