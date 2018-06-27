//
//  CartPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class CartPresenter {
    
    var cartProducts = [CartProduct]() {
        didSet {
            view?.displayTotals(totalCount: cartProducts.count, totalPrice: cartProducts.reduce(0) { $0 + $1.price * Double($1.count)})
        }
    }
    
    weak var view: CartPresenterToViewProtocol?
    
    var interactor: CartPresentorToInterectorProtocol
    var router: CartPresenterToRouterProtocol

    required init(with interactor: CartPresentorToInterectorProtocol, router: CartPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
    deinit {
        print("Cart deinit")
    }
    
}

extension CartPresenter: CartViewToPresenterProtocol {

    func loadImage(from product: CartProduct, for cell: ImageCellProtocol) {
        guard let referenceURL = product.imageURL else {
            cell.setCellImage(imageData: nil)
            return
        }
        interactor.downloadImage(from: referenceURL) { (data) in
            cell.setCellImage(imageData: data)
        }
    }
    
    func loadCart() {
        interactor.fetchCart()
    }
    
    func cartProductsCount() -> Int {
        return cartProducts.count
    }
    
    func cartProduct(at index: Int) -> CartProduct {
        return cartProducts[index]
    }
    
    func cartProductDeleteButtonPressed(at index: Int) {
        interactor.deleteCartProduct(product: cartProducts[index])
    }
    
    func cartCountEditedForProduct(at index: Int, newCount: Int) {
        cartProduct(at: index).count = Int32(newCount)
        interactor.saveUpdatesPresistently()
    }
    
}

extension CartPresenter: CartInterectorToPresenterProtocol {

    func cartFetched(cartProducts: [CartProduct]) {
        self.cartProducts = cartProducts
        view?.displayCart()
    }
    
    func productAddedToCart(product: CartProduct, at indexPath: IndexPath) {
        cartProducts.append(product)
        view?.displayCartUpdate(at: indexPath, action: .insert)
    }
    
    func productUpdatedInCart(product: CartProduct, at indexPath: IndexPath) {
        cartProducts[indexPath.row] = product
        view?.displayCartUpdate(at: indexPath, action: .reload)
    }
    
    func productDeletedFromCart(at indexPath: IndexPath) {
        cartProducts.remove(at: indexPath.row)
        view?.displayCartUpdate(at: indexPath, action: .delete)
    }
    
    func errorOccured(error: String) {
        view?.displayError(error: error)
    }
    
}
