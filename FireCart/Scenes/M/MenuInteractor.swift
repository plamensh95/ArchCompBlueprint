//
//  MenuInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation

class MenuInteractor: MenuPresentorToInterectorProtocol {

    weak var presenter: MenuInterectorToPresenterProtocol?
    
    // MARK: - PresentorToInterectorProtocol
    func fetchMenu() {
        FRTFirestoreService.shared.read(from: .categories, returning: Category.self) { (categories) in
            var menu = categories
            for i in 0..<categories.count {
                FRTFirestoreService.shared.read(from: .products, for: categories[i].id ?? "", in: .categories, returning: Product.self, completion: { (products) in
                    menu[i].products = products
                    if i == categories.count - 1 {
                        self.presenter?.menuFetched(content: menu)
                    }
                })
            }
        }
    }
    
    func downloadImage(from referenceURL: String, completion: @escaping (Data?) -> ()) {
        FRTFirestoreService.shared.downloadImage(from: referenceURL) { (data) in
            completion(data)
        }
    }
    
    deinit {
        print("Menu deinit")
    }
}
