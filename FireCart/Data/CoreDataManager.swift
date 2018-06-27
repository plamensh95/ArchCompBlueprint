//
//  CoreDataManager.swift
//  FireCart
//
//  Created by Plamen Iliev on 25.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    class func create(product: FRTProduct, completion: @escaping (Result) -> ()) {
        if let cartProduct = fetchCartProduct(id: product.id ?? "") {
            cartProduct.count += 1
        } else {
            let cartProduct = NSEntityDescription.insertNewObject(forEntityName: EntityName.cartProduct.rawValue, into: appDelegate.persistentContainer.viewContext) as! CartProduct
            cartProduct.id = product.id
            cartProduct.name = product.name
            cartProduct.price = product.price ?? 0
            cartProduct.size = product.size ?? 0
            cartProduct.imageURL = product.imageURL
            cartProduct.count = 1
        }
        saveContext() { (result) in
            completion(result)
        }
    }
    
    class func delete(product: CartProduct, completion: @escaping (Result) -> ()) {
        appDelegate.persistentContainer.viewContext.delete(product)
        saveContext() { (result) in
            completion(result)
        }
    }
    
    class func saveContext(completion: @escaping (Result) -> ()) {
        do {
            try appDelegate.persistentContainer.viewContext.save()
            completion(.success(result: nil))
        } catch let error{
            print(error.localizedDescription)
            completion(.error(error as NSError))
        }
    }
    
    class func fetchCartProduct(id: String) -> CartProduct? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.cartProduct.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id contains [c] %@", id)
        do {
            guard let fetchResults = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as? [CartProduct] else {
                return nil
            }
            return fetchResults.count > 0 ? fetchResults[0] : nil
        } catch let error{
            print(error.localizedDescription)
        }
        return nil
    }
}
