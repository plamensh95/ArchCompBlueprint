//
//  EncodableExtension.swift
//  FireCart
//
//  Created by Plamen Iliev on 11.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSON(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectDData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectDData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw JSONError.encodingError }
        keys.forEach{ json[$0] = nil }
        return json
    }
}
