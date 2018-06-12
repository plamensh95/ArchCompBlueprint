//
//  LoginProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol LoginViewToPresenterProtocol: class{
    func facebookButtonPressed()
    func googleButtonPressed()
    func phoneButtonPressed(phoneNumber: String)
    func registerButtonPressed()
    func loginUser(with email: String, and password: String)
}

//Presenter -> ViewController
protocol LoginPresenterToViewProtocol: class{
    func displayError(error: String)
}

//Presenter -> Router
protocol LoginPresenterToRouterProtocol: class{
    func navigateToRegisterScene()
}

//Presenter -> Interactor
protocol LoginPresentorToInterectorProtocol: class{
    func authenticate(with provider: Provider, phoneNumber: String?)
    func loginUser(with email: String, and password: String)
}

//Interactor -> Presenter
protocol LoginInterectorToPresenterProtocol: class{
    func loggedInSuccessfuly()
    func errorOccured(error: String)
}






