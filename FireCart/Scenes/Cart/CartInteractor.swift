//
//  CartInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class CartInteractor: CartPresentorToInterectorProtocol {
    
    weak var presenter: CartInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func fetchData() {
        // InterectorToPresenterProtocol
        // Do some job and callback when ready
         self.presenter?.dataFetched()
    }
    
    deinit {
        print("Cart deinit")
    }
}
