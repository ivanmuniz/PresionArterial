//
//  DetallesPacienteTableViewController.swift
//  PresionArterial
//
//  Created by alumno on 11/21/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase

class DetallesPacienteTableViewController: UITableViewController, protocolDataFetched {
    
    var diastolica1 = [Int]()
    var sistolica1 = [Int]()
    
    func dataReady() {
        tableView.reloadData()
    }
    let alturaCelda: CGFloat! = 95.00
    var delegatePresionesListas: protocolDataFetched!
    var presiones = [Presion]()
   // let usuario: Usuario! = Usuario.getInstance()
    var userUID: String!
    let db = DBHandler().getDB()
    
    override func viewDidLoad() {
        diastolica1.removeAll()
        sistolica1.removeAll()
        super.viewDidLoad()
        title = "Lista de presiones"
        delegatePresionesListas = self
        fetchPresiones()
    }
    
    func fetchPresiones() {
        let docRef = db.collection("users").document(userUID).collection("presion")
        docRef.getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let aux = Presion()
                    aux.iSistolica = document["sistolica"] as? Int
                    aux.iDiastolica = document["diastolica"] as? Int
                    aux.iPulso = document["pulso"] as? Int
                    aux.timestamp = document["dateAdded"] as? Timestamp
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm - dd/MM/yyy"
                    let result = formatter.string(from: aux.timestamp.dateValue())
                    aux.sTimeStamp = result
                    self.presiones.append(aux)
                }
            }
            self.delegatePresionesListas.dataReady()
        }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presiones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detallesPacientes", for: indexPath) as! PresionT2TableViewCell
        cell.lbDiastolica.text = "\(presiones[indexPath.row].iDiastolica!)"
        cell.lbSistolica.text = "\(presiones[indexPath.row].iSistolica!)"
        cell.lbPulso.text = "\(presiones[indexPath.row].iPulso!)"
        cell.lbFecha.text = "\(presiones[indexPath.row].sTimeStamp!)"
        
        sistolica1.append(presiones[indexPath.row].iSistolica!)
        diastolica1.append(presiones[indexPath.row].iDiastolica!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return alturaCelda
    }
    
    @IBAction func graficar(_ sender: Any) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // if (segue.identifier == "graficarPacientes1") {
            let registrarPresion = segue.destination as! GraficarPacientesViewController
            registrarPresion.sistolica = sistolica1
            registrarPresion.diastolica = diastolica1
            
        // }
        
    }
}
