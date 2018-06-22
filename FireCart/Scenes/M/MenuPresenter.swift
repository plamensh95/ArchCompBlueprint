//
//  MenuPresenter.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class MenuPresenter {
    
    weak var view: MenuPresenterToViewProtocol?
    
    var interactor: MenuPresentorToInterectorProtocol
    var router: MenuPresenterToRouterProtocol

    required init(with interactor: MenuPresentorToInterectorProtocol, router: MenuPresenterToRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
    }
    
    deinit {
        print("Menu deinit")
    }
}

extension MenuPresenter: MenuViewToPresenterProtocol {
    func loadMenu() {
        interactor.fetchMenu()
    }
    
    func loadImage(from product: Product, for cell: ProductCellProtocol) {
        guard let referenceURL = product.imageURL else {
            cell.setCellImage(imageData: nil)
            return
        }
        interactor.downloadImage(from:referenceURL) { (data) in
            cell.setCellImage(imageData: data)
        }
    }
    
}

extension MenuPresenter: MenuInterectorToPresenterProtocol {
    func menuFetched(content: [Category]) {
        view?.displayMenu(content: content)
    }
    
}
