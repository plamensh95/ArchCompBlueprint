//
//  OrdersPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class OrdersPresenter {
    
    weak var view: OrdersPresenterToViewProtocol?
    
    var interactor: OrdersPresentorToInterectorProtocol
    var router: OrdersPresenterToRouterProtocol

    required init(with interactor: OrdersPresentorToInterectorProtocol, router: OrdersPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
    deinit {
        print("Orders deinit")
    }
    
}

extension OrdersPresenter: OrdersViewToPresenterProtocol {
    
}

extension OrdersPresenter: OrdersInterectorToPresenterProtocol {
    func dataFetched() {
        
    }
    
    
}
