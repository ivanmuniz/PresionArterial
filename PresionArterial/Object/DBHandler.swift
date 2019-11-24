//
//  Firebase.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 02/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DBHandler: NSObject {
    private var db: Firestore!
    
    override init() {
        db = Firestore.firestore()
    }
    
    func getDB() -> Firestore {
        return db
    }
}
