//
//  User.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? {get set}
}

struct User: Codable, Identifiable{
    var id: String?
    
    var name: String?
    var email: String?
    
    init(id: String? = nil, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
