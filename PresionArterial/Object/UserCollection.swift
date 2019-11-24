//
//  UserCollection.swift
//  PresionArterial
//
//  Created by alumno on 11/21/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase

class UserCollection: NSObject {
    var usuarios = [UsuarioNormal]()
    var delegatePacientesFetched: protocolPacientesFetched!
    static var _instance: UserCollection! = nil
    
    
    public static func getInstance() -> UserCollection {
        if _instance == nil {
            _instance = UserCollection()
        }
        return _instance
    }
    
    func fetchPacientes()  {
        let db = DBHandler().getDB()
        let docRef = db.collection("users").whereField("userType", isEqualTo: "Paciente")
        docRef.addSnapshotListener { (querySnapshot, err) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                if (diff.type == .added) {
                    let aux = UsuarioNormal()
                    aux.apellido = diff.document["lastName"] as? String
                    aux.nombre = diff.document["firstName"] as? String
                    aux.edad = diff.document["edad"] as? Int
                    aux.telefono = diff.document["telefono"] as? String
                    aux.peso = diff.document["peso"] as? Int
                    aux.uid = diff.document["uid"] as? String
                    aux.circAbd = diff.document["circAbd"] as? Int
                    self.usuarios.append(aux)
                    print(aux.nombre!)
                }
                if (diff.type == .modified) {
                    
                }
                if (diff.type == .removed) {
                    
                }
            }
            self.delegatePacientesFetched.reloadTableView()
        }
    }
    
    func cleanInstance() -> Void {
        usuarios.removeAll()
//        listenerUserData.remove()
//        listenerUserPressure.remove()
        UserCollection._instance = nil
    }

}

