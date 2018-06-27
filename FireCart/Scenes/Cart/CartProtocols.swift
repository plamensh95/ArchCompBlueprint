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
    func loadCart()
    func loadImage(from product: CartProduct, for cell: ImageCellProtocol)
    func cartProductsCount() -> Int
    func cartProduct(at index: Int) -> CartProduct
    func cartProductDeleteButtonPressed(at index: Int)
    func cartCountEditedForProduct(at index: Int, newCount: Int)
}

//Presenter -> ViewController
protocol CartPresenterToViewProtocol: class{
    func displayCart()
    func displayCartUpdate(at indexPath: IndexPath, action: TableViewRowAction)
    func displayTotals(totalCount: Int, totalPrice: Double)
    func displayError(error: String)
}

//Presenter -> Router
protocol CartPresenterToRouterProtocol: class{
    func navigateToSomewhere();
}

//Presenter -> Interactor
protocol CartPresentorToInterectorProtocol: class{
    func fetchCart()
    func downloadImage(from referenceURL: String, completion: @escaping(Data?) -> ())
    func deleteCartProduct(product: CartProduct)
    func saveUpdatesPresistently()
}

//Interactor -> Presenter
protocol CartInterectorToPresenterProtocol: class{
    func cartFetched(cartProducts: [CartProduct])
    func errorOccured(error: String)
    func productAddedToCart(product: CartProduct, at indexPath: IndexPath)
    func productUpdatedInCart(product: CartProduct, at indexPath: IndexPath)
    func productDeletedFromCart(at indexPath: IndexPath)
}






