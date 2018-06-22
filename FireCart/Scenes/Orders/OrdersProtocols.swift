//
//  OrdersProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol OrdersViewToPresenterProtocol: class{
    //func updateView();
}

//Presenter -> ViewController
protocol OrdersPresenterToViewProtocol: class{
    func displaySomething()
}

//Presenter -> Router
protocol OrdersPresenterToRouterProtocol: class{
    func navigateToSomewhere();
}

//Presenter -> Interactor
protocol OrdersPresentorToInterectorProtocol: class{
    func fetchData();
}

//Interactor -> Presenter
protocol OrdersInterectorToPresenterProtocol: class{
    func dataFetched();
}






