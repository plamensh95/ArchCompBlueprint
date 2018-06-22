//
//  MenuProtocols.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

//ViewController -> Presenter
protocol MenuViewToPresenterProtocol: class{
    func loadMenu()
    func loadImage(from product: Product, for cell: ProductCellProtocol)
}

//Presenter -> ViewController
protocol MenuPresenterToViewProtocol: class{
    func displayMenu(content: [Category])
}

//Presenter -> Router
protocol MenuPresenterToRouterProtocol: class{
    func navigateToSomewhere()
}

//Presenter -> Interactor
protocol MenuPresentorToInterectorProtocol: class{
    func downloadImage(from referenceURL: String, completion: @escaping(Data?) -> ())
    func fetchMenu()
}

//Interactor -> Presenter
protocol MenuInterectorToPresenterProtocol: class{
    func menuFetched(content: [Category])
}






