//
//  FRTFirestoreService.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum FSCollectionReference: String {
    case users
    case categories
}

enum FSSubCollectionReference: String {
    case products
}

enum StorageDirectories: String {
    case Products
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
    
    func read<T: Decodable>(from collectionReference: FSCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            var returnedObjects = [T]()
            for document in snapshot.documents {
                do {
                    try returnedObjects.append(document.decode(as: objectType))
                } catch {
                    print(error)
                }
            }
            completion(returnedObjects)
        }
    }
    
    func read<T: Decodable>(from subCollectionReference: FSSubCollectionReference, for documentPath: String, in collectionReference: FSCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        let ref = reference(to: collectionReference).document(documentPath).collection(subCollectionReference.rawValue)
        ref.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            var returnedObjects = [T]()
            for document in snapshot.documents {
                do {
                    try returnedObjects.append(document.decode(as: objectType))
                } catch {
                    print(error)
                }
            }
            completion(returnedObjects)
        }
    }
    
    func downloadImage(from referenceURL: String, completion: @escaping(Data?) -> ()) {
        Storage.storage().reference(forURL: referenceURL).getData(maxSize: 1 * 1024 * 1024)
        { (data, error) in
            completion(data)
        }
    }
}

extension QueryDocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        var documentJSON = data()
        if includingId {
            documentJSON["id"] = documentID
        }
        
        let documentData =  try JSONSerialization.data(withJSONObject: documentJSON, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
