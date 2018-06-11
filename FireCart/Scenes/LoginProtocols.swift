//
//  LoginProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import UIKit.UIViewController

//ViewController -> Presenter
protocol LoginViewToPresenterProtocol: class{
    func facebookButtonPressed(from viewController: UIViewController)
    func googleButtonPressed(from viewController: UIViewController)
    func phoneButtonPressed(from viewController: UIViewController, phoneNumber: String)
    func logoutButtonPressed()
}

//Presenter -> ViewController
protocol LoginPresenterToViewProtocol: class{
    func displaySomething()
}

//Presenter -> Router
protocol LoginPresenterToRouterProtocol: class{
    func navigateToSomewhere();
}

//Presenter -> Interactor
protocol LoginPresentorToInterectorProtocol: class{
    func fetchData();
    func authenticate(with provider: Provider,from viewController: UIViewController?, phoneNumber: String?)
    func logoutButtonPressed()
}

//Interactor -> Presenter
protocol LoginInterectorToPresenterProtocol: class{
    func dataFetched();
}






