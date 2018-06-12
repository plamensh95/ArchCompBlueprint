//
//  FRTFirestoreService.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FSCollectionReference: String {
    case users
}

class FRTFirestoreService {
    private init() {}
    public static let shared = FRTFirestoreService()
    lazy var firestore: Firestore = {
        let firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
        return firestore
    }()
    
    private func reference(to collectionReference: FSCollectionReference) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }
    
    func create<T: Encodable>(object: T, in collectionReference: FSCollectionReference, completion: @escaping (Bool, NSError?) -> ()) {
        do {
            let json = try object.toJSON(excluding: ["id"])
            reference(to: collectionReference).addDocument(data: json)
            completion(true, nil)
        } catch {
            print(error)
            completion(false, error as NSError)
        }
    }
}
