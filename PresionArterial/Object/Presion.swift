//
//  Presion.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 14/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
class Presion: NSObject {
    var id: String!
    var iSistolica: Int! = 0
    var iDiastolica: Int! = 0
    var iPulso: Int! = 0
    var timestamp: Timestamp!
    var sTimeStamp: String!
    
    override init() {
        
    }
    
    init(iSistolica: Int!, iDiastolica: Int!, iPulso: Int!, timestamp: Timestamp!, sTimeStamp: String!) {
        self.iSistolica = iSistolica
        self.iDiastolica = iDiastolica
        self.iPulso = iPulso
        self.timestamp = timestamp
        self.sTimeStamp = sTimeStamp
    }
}
