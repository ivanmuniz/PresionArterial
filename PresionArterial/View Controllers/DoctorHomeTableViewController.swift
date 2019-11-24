//
//  DoctorHomeTableViewController.swift
//  PresionArterial
//
//  Created by Alumno on 11/20/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


protocol protocolPacientesFetched {
    func reloadTableView()
}

class DoctorHomeTableViewController: UITableViewController, protocolPacientesFetched {
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    let usuario: Usuario! = Usuario.getInstance()
    let usersCollection = UserCollection.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorStyle = .none
        title = "Pacientes"
        usersCollection.delegatePacientesFetched = self
        usersCollection.fetchPacientes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersCollection.usuarios.count
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if let storyboard = self.storyboard {
                let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as! UINavigationController
                view.window?.rootViewController = homeViewController
                view.window?.makeKeyAndVisible()
                usuario.cleanInstance()
                usersCollection.cleanInstance()
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPacienteD", for: indexPath)
        cell.textLabel?.text = usersCollection.usuarios[indexPath.row].nombre! + " " + usersCollection.usuarios[indexPath.row].apellido!
        cell.detailTextLabel?.text = "\(usersCollection.usuarios[indexPath.row].edad!)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detallesPacientesDoc") {
            let registrarPresion = segue.destination as! DetallesPacienteTableViewController
            let indice = tableView.indexPathForSelectedRow
            registrarPresion.userUID = usersCollection.usuarios[indice!.row].uid
         }
        
    }
}
