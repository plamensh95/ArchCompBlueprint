//
//  CartProduct+CoreDataProperties.swift
//  
//
//  Created by Plamen Iliev on 26.06.18.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var categoryID: String?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var size: Double
    @NSManaged public var count: Int32

}
