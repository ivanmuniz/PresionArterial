//
//  Usuario.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 14/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol protocolDataFetched {
    func dataReady()
}

class Usuario: NSObject {
    var delegate: protocolDataFetched!
    private var listenerUserData: ListenerRegistration!
    private var listenerUserPressure: ListenerRegistration!
    
    private var uid: String!
    var nombre: String!
    var apellido: String!
    var telefono: String!
    var peso: Int!
    var edad: Int!
    var circAbd: Int!
    var userType: String!
    var presion = [Presion]()
    static var _instance: Usuario! = nil
    
    public static func getInstance() -> Usuario {
        if _instance == nil {
            _instance = Usuario()
        }
        return _instance
    }
    
    override private init() {
        
    }
    
    private init(nombre: String, apellido: String) {
        self.nombre = nombre
        self.apellido = apellido
    }
    
    func getUid() -> String {
        return uid
    }
    
    func setUid(uid: String) -> Void {
        self.uid = uid
    }
    
    func fetchUserData() -> Void {
        let db = DBHandler().getDB()
        self.listenerUserData = db.collection("users").document(uid).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            print("Current data: \(data)")
            self.nombre = data["firstName"] as? String
            self.apellido = data["lastName"] as? String
            self.telefono = data["telefono"] as? String
            self.peso = data["peso"] as? Int
            self.edad = data["edad"] as? Int
            self.circAbd = data["circAbd"] as? Int
            self.userType = data["userType"] as? String
        }
        self.fetchPresion()
    }
    
    func fetchPresion() -> Void {
        let db = DBHandler().getDB()
        self.listenerUserPressure = db.collection("users").document(uid).collection("presion").order(by: "dateAdded", descending: true).addSnapshotListener { querySnapshot, err in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let aux = Presion()
                    aux.id = diff.document.documentID
                    aux.iDiastolica = diff.document["diastolica"] as? Int
                    aux.iSistolica = diff.document["sistolica"] as? Int
                    aux.iPulso = diff.document["pulso"] as? Int
                    aux.timestamp = diff.document["dateAdded"] as? Timestamp
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm - dd/MM/yyy"
                    let result = formatter.string(from: aux.timestamp.dateValue())
                    print(result)
                    aux.sTimeStamp = result
                    self.presion.append(aux)
                    print("Presión agregada: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    for p in self.presion {
                        if (p.id == diff.document.documentID) {
                            p.iDiastolica = diff.document["diastolica"] as? Int
                            p.iSistolica = diff.document["sistolica"] as? Int
                            p.iPulso = diff.document["pulso"] as? Int
                                // TODO: RELOAD AL TABLE VIEW
                        }
                    }
                    print("Presión modificada: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    var i = 0
                    for p in self.presion {
                        if (p.id == diff.document.documentID) {
                            self.presion.remove(at: i)
                        }
                        i+=1
                    }
                    print("Presion removida: \(diff.document.data())")
                }
            }
        self.delegate.dataReady()
        }
    }
    
    func cleanInstance() -> Void {
        presion.removeAll()
        listenerUserData.remove()
        listenerUserPressure.remove()
        Usuario._instance = nil
    }
}
