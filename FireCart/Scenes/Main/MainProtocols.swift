//
//  MainProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 25.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol MainViewToPresenterProtocol: class{
    func logoutButtonPressed()
}

//Presenter -> ViewController
protocol MainPresenterToViewProtocol: class{
    func displayError(error: String)
}

//Presenter -> Router
protocol MainPresenterToRouterProtocol: class{
    func navigateToLoginScene()
}

//Presenter -> Interactor
protocol MainPresentorToInterectorProtocol: class{
    func logoutUser()
}

//Interactor -> Presenter
protocol MainInterectorToPresenterProtocol: class{
    func loggedOutUser()
    func errorOccured(error: String)
}






