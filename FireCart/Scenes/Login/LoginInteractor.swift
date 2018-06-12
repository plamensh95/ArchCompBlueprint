//
//  LoginInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class LoginInteractor: LoginPresentorToInterectorProtocol {

    var presenter: LoginInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol

    func authenticate(with provider: Provider, phoneNumber: String?) {
        FRTAuthenticationService.shared.signIn(using: provider, phoneNumber: phoneNumber) { (result) in
            switch result {
            case .success(result: _):
                self.presenter?.loggedInSuccessfuly()
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
                break
            }
        }
    }
    
    func loginUser(with email: String, and password: String) {
        FRTAuthenticationService.shared.loginUser(with: email, and: password) { (result) in
            switch result {
            case .success(result: _):
                self.presenter?.loggedInSuccessfuly()
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
                break
            }
        }
        
    }
}
