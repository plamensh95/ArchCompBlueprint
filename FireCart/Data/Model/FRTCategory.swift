//
//  Category.swift
//  FireCart
//
//  Created by Plamen Iliev on 19.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import UIKit

struct FRTCategory: Codable, Identifiable {
    var id: String?
    var name: String?
    var products: [FRTProduct]?
    
    init(id: String? = nil, name: String, products: [FRTProduct]) {
        self.id = id
        self.name = name
        self.products = products
    }
}
