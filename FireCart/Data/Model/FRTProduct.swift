//
//  Product.swift
//  FireCart
//
//  Created by Plamen Iliev on 19.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation

struct FRTProduct: Codable, Identifiable {
    var id: String?
    var name: String?
    var price: Double?
    var size: Double?
    var ingredients: String?
    var imageURL: String?
    
    init(id: String? = nil, name: String, price: Double, size: Double, ingredients: String, imageURL: String) {
        self.id = id
        self.name = name
        self.price = price
        self.size = size
        self.ingredients = ingredients
    }
}
