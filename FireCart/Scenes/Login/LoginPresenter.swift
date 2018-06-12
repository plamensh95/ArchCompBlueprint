//
//  LoginPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class LoginPresenter {
    
    weak var view: LoginPresenterToViewProtocol?
    
    var interactor: LoginPresentorToInterectorProtocol
    var router: LoginPresenterToRouterProtocol

    required init(with interactor: LoginPresentorToInterectorProtocol, router: LoginPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
}

extension LoginPresenter: LoginViewToPresenterProtocol {
    func loginUser(with email: String, and password: String) {
        interactor.loginUser(with: email, and: password)
    }
    
    func facebookButtonPressed() {
        interactor.authenticate(with: .facebook, phoneNumber: nil)
    }
    
    func googleButtonPressed() {
        interactor.authenticate(with: .facebook, phoneNumber: nil)
    }
    
    func phoneButtonPressed(phoneNumber: String) {
        interactor.authenticate(with: .phone, phoneNumber: phoneNumber)
    }
    
    func registerButtonPressed() {
        router.navigateToRegisterScene()
    }
    
}

extension LoginPresenter: LoginInterectorToPresenterProtocol {
    
    func loggedInSuccessfuly() {
        
        print("Login successful")
    }
    
    func errorOccured(error: String) {
        view?.displayError(error: error)
    }
    
}
