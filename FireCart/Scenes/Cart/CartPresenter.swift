//
//  CartPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class CartPresenter {
    
    weak var view: CartPresenterToViewProtocol?
    
    var interactor: CartPresentorToInterectorProtocol
    var router: CartPresenterToRouterProtocol

    required init(with interactor: CartPresentorToInterectorProtocol, router: CartPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
    deinit {
        print("Cart deinit")
    }
    
}

extension CartPresenter: CartViewToPresenterProtocol {
    
}

extension CartPresenter: CartInterectorToPresenterProtocol {
    func dataFetched() {
        
    }
    
    
}
