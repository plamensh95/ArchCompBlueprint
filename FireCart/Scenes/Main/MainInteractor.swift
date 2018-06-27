//
//  MainInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 25.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class MainInteractor: MainPresentorToInterectorProtocol {

    var presenter: MainInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func logoutUser() {
        FRTAuthenticationService.shared.logout { (result) in
            switch result {
            case .success(result: _):
                self.presenter?.loggedOutUser()
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
            }
        }
        
    }

}
