//
//  LoginInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class LoginInteractor: LoginPresentorToInterectorProtocol {
    
    var presenter: LoginInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol

    func authenticate(with provider: Provider, from viewController: UIViewController?, phoneNumber: String?) {
        FRTAuthenticationService.shared.signIn(using: provider, from: viewController, phoneNumber: phoneNumber)
    }
    
    func logoutButtonPressed() {
        FRTAuthenticationService.shared.logout()
    }
    
    func fetchData() {
        // InterectorToPresenterProtocol
        // Do some job and callback when ready
         self.presenter?.dataFetched()
    }
}
