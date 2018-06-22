//
//  OrdersConfigurator.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

// MARK: - Configuration
class OrdersConfigurator {
    
    class func configure(viewController: OrdersViewController) {
        
        let router = OrdersRouter()
        let interactor = OrdersInteractor()
        let presenter = OrdersPresenter(with: interactor, router: router)
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.viewController = viewController
        viewController.presenter = presenter
    }
}
