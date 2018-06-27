//
//  RegisterInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class RegisterInteractor: RegisterPresentorToInterectorProtocol {

    var presenter: RegisterInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func registerUser(with username: String, email: String, password: String) {
        FRTAuthenticationService.shared.registerUser(with: username, email: email, and: password) { (result) in
            switch result {
            case .success(result: _):
                self.presenter?.userSuccessfullyRegistered()
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
            }
        }
    }
}
