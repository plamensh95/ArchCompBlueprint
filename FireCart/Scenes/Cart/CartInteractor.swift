//
//  CartInteractor.swift
//  FireCart
//
//  Created by Plamen Iliev on 15.06.18.
//  Copyright (c) 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import CoreData

class CartInteractor: NSObject, CartPresentorToInterectorProtocol, NSFetchedResultsControllerDelegate {

    weak var presenter: CartInterectorToPresenterProtocol?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override init() {
        super.init()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.cartProduct.rawValue)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }
    
    // MARK: - PresentorToInterectorProtocol
    func fetchCart() {
        do {
            try fetchedResultsController.performFetch()
            presenter?.cartFetched(cartProducts: fetchedResultsController.fetchedObjects as! [CartProduct])
        } catch {
            print("error fetching")
        }
    }
    
    func downloadImage(from referenceURL: String, completion: @escaping (Data?) -> ()) {
        FRTFirestoreService.shared.downloadImage(from: referenceURL) { (data) in
            completion(data)
        }
    }
    
    func deleteCartProduct(product: CartProduct) {
        CoreDataManager.delete(product: product) { (result) in
            switch result {
            case .success(result: _):
                break
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
            }
        }
    }
    
    func saveUpdatesPresistently() {
        CoreDataManager.saveContext { (result) in
            switch result {
            case .success(result: _):
                break
            case .error(let error):
                self.presenter?.errorOccured(error: error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("Cart deinit")
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            presenter?.productAddedToCart(product: fetchedResultsController.object(at: newIndexPath!) as! CartProduct, at: newIndexPath!)
        case .update:
            presenter?.productUpdatedInCart(product: fetchedResultsController.object(at: newIndexPath!) as! CartProduct, at: indexPath!)
        case .delete:
            presenter?.productDeletedFromCart(at: indexPath!)
        default:
            break
        }
    }
}
