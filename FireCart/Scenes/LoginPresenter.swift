//
//  LoginPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import UIKit.UIViewController

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
    
    func facebookButtonPressed(from viewController: UIViewController) {
        interactor.authenticate(with: .facebook, from: viewController, phoneNumber: nil)
    }
    
    func googleButtonPressed(from viewController: UIViewController) {
        interactor.authenticate(with: .facebook, from: nil, phoneNumber: nil)
    }
    
    func phoneButtonPressed(from viewController: UIViewController, phoneNumber: String) {
        interactor.authenticate(with: .phone, from: nil, phoneNumber: phoneNumber)
    }
    
    func logoutButtonPressed() {
        interactor.logoutButtonPressed()
    }
    
}

extension LoginPresenter: LoginInterectorToPresenterProtocol {
    func dataFetched() {
        
    }
    
    
}
