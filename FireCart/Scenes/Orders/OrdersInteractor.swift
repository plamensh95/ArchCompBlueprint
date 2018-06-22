//
//  OrdersInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class OrdersInteractor: OrdersPresentorToInterectorProtocol {
    
    weak var presenter: OrdersInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func fetchData() {
        // InterectorToPresenterProtocol
        // Do some job and callback when ready
         self.presenter?.dataFetched()
    }
    
    deinit {
        print("Orders deinit")
    }
}
