//
//  MainInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 13.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class MainInteractor: MainPresentorToInterectorProtocol {
    
    var presenter: MainInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func fetchData() {
        // InterectorToPresenterProtocol
        // Do some job and callback when ready
         self.presenter?.dataFetched()
    }
}
