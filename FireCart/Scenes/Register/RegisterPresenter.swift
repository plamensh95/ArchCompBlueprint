//
//  RegisterPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class RegisterPresenter {
    
    weak var view: RegisterPresenterToViewProtocol?
    
    var interactor: RegisterPresentorToInterectorProtocol
    var router: RegisterPresenterToRouterProtocol

    required init(with interactor: RegisterPresentorToInterectorProtocol, router: RegisterPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
}

extension RegisterPresenter: RegisterViewToPresenterProtocol {

    func registerButtonPressed(with username: String, email: String, password: String) {
        interactor.registerUser(with: username, email: email, password: password)
    }
    
    func procceedToLogin() {
        router.navigateToLoginScene()
    }
    
}

extension RegisterPresenter: RegisterInterectorToPresenterProtocol {
    func errorOccured(error: String) {
        view?.displayError(error: error)
    }
    
    func userSuccessfullyRegistered() {
        view?.displaySuccessDialog()
    }
    
}
