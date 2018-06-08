//
//  FRTFirebaseService.swift
//  FireCart
//
//  Created by Plamen Iliev on 8.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FRTFirestoreService {
    private init() {}
    public static let shared = FRTFirestoreService()
    
    lazy var db: Firestore = {
        let firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        firestore.settings = settings
        return firestore
    }()
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
}
