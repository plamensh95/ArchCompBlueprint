//
//  DoubleExtension.swift
//  FireCart
//
//  Created by Plamen Iliev on 27.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
