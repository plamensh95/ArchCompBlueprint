//
//  RegisterProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol RegisterViewToPresenterProtocol: class{
    func registerButtonPressed(with username:String, email: String, password: String)
    func procceedToLogin()
}

//Presenter -> ViewController
protocol RegisterPresenterToViewProtocol: class{
    func displayError(error: String)
    func displaySuccessDialog()
}

//Presenter -> Router
protocol RegisterPresenterToRouterProtocol: class{
    func navigateToLoginScene()
}

//Presenter -> Interactor
protocol RegisterPresentorToInterectorProtocol: class{
    func registerUser(with username:String, email: String, password: String)
}

//Interactor -> Presenter
protocol RegisterInterectorToPresenterProtocol: class{
    func userSuccessfullyRegistered()
    func errorOccured(error: String)
}






