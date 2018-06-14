//
//  MainProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 13.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol MainViewToPresenterProtocol: class{
    //func updateView();
}

//Presenter -> ViewController
protocol MainPresenterToViewProtocol: class{
    func displaySomething()
}

//Presenter -> Router
protocol MainPresenterToRouterProtocol: class{
    func navigateToSomewhere();
}

//Presenter -> Interactor
protocol MainPresentorToInterectorProtocol: class{
    func fetchData();
}

//Interactor -> Presenter
protocol MainInterectorToPresenterProtocol: class{
    func dataFetched();
}






