//
//  CartProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol CartViewToPresenterProtocol: class{
    //func updateView();
}

//Presenter -> ViewController
protocol CartPresenterToViewProtocol: class{
    func displaySomething()
}

//Presenter -> Router
protocol CartPresenterToRouterProtocol: class{
    func navigateToSomewhere();
}

//Presenter -> Interactor
protocol CartPresentorToInterectorProtocol: class{
    func fetchData();
}

//Interactor -> Presenter
protocol CartInterectorToPresenterProtocol: class{
    func dataFetched();
}






