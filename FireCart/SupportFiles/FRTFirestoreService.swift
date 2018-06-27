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
    case products
    case cart
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
    
    private func buildReferencePath(for documentPaths: [String], in collectionReferences: [FSCollectionReference]) -> (DocumentReference?, CollectionReference?) {
        var docRef: DocumentReference?
        var colRef: CollectionReference = reference(to: collectionReferences[0])
        for i in 0..<max(documentPaths.count, collectionReferences.count) {
            if i > 0 && i < collectionReferences.count {
                colRef = docRef!.collection(collectionReferences[i].rawValue)
            }
            if i < documentPaths.count {
                docRef = colRef.document(documentPaths[i])
            }
        }
        return (collectionReferences.count + documentPaths.count) % 2 == 0 ? (docRef, nil) : (nil, colRef)
    }
    
    func documentExists(documentPath: String, in collectionReference: FSCollectionReference, completion: @escaping(Bool) -> ()) {
        reference(to: collectionReference).document(documentPath).getDocument { (document, error) in
            if let document = document {
                completion(document.exists)
            }
        }
    }
    
    func create<T: Codable & Identifiable>(object: T, documentPaths: [String], collectionReferences: [FSCollectionReference], completion: @escaping (Result) -> ()) {
        do {
            let json = try object.toJSON(excluding: ["id"])
            let references = buildReferencePath(for: documentPaths, in: collectionReferences)
            if let docRef = references.0 {
                docRef.setData(json)
                completion(.success(result: nil))
            } else if let colRef = references.1 {
                colRef.addDocument(data: json)
                completion(.success(result: nil))
            }
        }
        catch {
            print(error)
            completion(.error(error as NSError))
        }
    }
    
    func read<T: Decodable>(for documentPaths: [String], in collectionReferences: [FSCollectionReference], returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        var returnedObjects = [T]()
        let references = buildReferencePath(for: documentPaths, in: collectionReferences)
        if let documentReference = references.0 {
            documentReference.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    do {
                        try returnedObjects.append(document.decode(as: objectType))
                        completion(returnedObjects)
                    } catch {
                        print(error)
                    }
                }
            })
        } else if let collectionReference = references.1 {
            collectionReference.addSnapshotListener { (snapshot, _) in
                guard let snapshot = snapshot else { return }
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
    }
    
    func downloadImage(from referenceURL: String, completion: @escaping(Data?) -> ()) {
        Storage.storage().reference(forURL: referenceURL).getData(maxSize: 1 * 1024 * 1024)
        { (data, error) in
            completion(data)
        }
    }
}

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        guard var documentJSON = data() else { throw(JSONError.decodingError) }
        if includingId {
            documentJSON["id"] = documentID
        }
        
        let documentData =  try JSONSerialization.data(withJSONObject: documentJSON, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObject
    }
}
