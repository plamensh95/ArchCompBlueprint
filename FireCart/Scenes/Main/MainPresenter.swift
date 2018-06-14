//
//  MainPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 13.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class MainPresenter {
    
    weak var view: MainPresenterToViewProtocol?
    
    var interactor: MainPresentorToInterectorProtocol
    var router: MainPresenterToRouterProtocol

    required init(with interactor: MainPresentorToInterectorProtocol, router: MainPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
}

extension MainPresenter: MainViewToPresenterProtocol {
    
}

extension MainPresenter: MainInterectorToPresenterProtocol {
    func dataFetched() {
        
    }
    
    
}
