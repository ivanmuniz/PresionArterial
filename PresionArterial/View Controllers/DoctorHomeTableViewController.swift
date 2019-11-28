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
    let handler: DBHandler! = DBHandler()
    var usuariosPacientes = [Int]()
    let usuario: Usuario! = Usuario.getInstance()
    let usersCollection = UserCollection._instance
    var actualEliminado = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorStyle = .none
        title = "Pacientes"
        usersCollection!.delegatePacientesFetched = self
        //usersCollection.fetchPacientes()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let regresar = usersCollection!.usuarios.count - usuario.eliminados.count + 1
        return regresar
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
            
                usersCollection!.cleanInstance()
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaPacienteD", for: indexPath)
        var contador = 0
        var aceptado = 0
        var rechazado = 0
       while aceptado < 1 {
             while contador <= usuario.eliminados.count - 1 {
                //print(actualEliminado)
                //print(usuario.eliminados[contador])
                
                //print(usersCollection?.usuarios[indexPath.row + actualEliminado])
                if usersCollection!.usuarios[indexPath.row + actualEliminado].uid == usuario.eliminados[contador] {
                        
                           actualEliminado = actualEliminado + 1
                    contador = usuario.eliminados.count + 1
                    
                           rechazado = 1
                
                            
                       }
                
                       
                contador = contador + 1

                }
        if rechazado == 0 {
            aceptado = 1
        }
        rechazado = 0
        contador = 0
        }
           
        
        usuariosPacientes.append(indexPath.row + actualEliminado)
        cell.textLabel?.text = usersCollection!.usuarios[indexPath.row + actualEliminado].nombre! + " " + usersCollection!.usuarios[indexPath.row + actualEliminado].apellido!
        if (usersCollection?.usuarios[indexPath.row + actualEliminado].edad != nil){
            cell.detailTextLabel?.text = "\(usersCollection!.usuarios[indexPath.row + actualEliminado].edad!)"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
        
    }
    
    //override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
    //}
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var elimActuales = usuario.eliminados
            elimActuales.append((usersCollection?.usuarios[usuariosPacientes[indexPath.row]].uid)!)
            
            handler.getDB().collection("users").document(usuario.getUid()).setData(["eliminados" : elimActuales, "firstName" : usuario.nombre, "lastName" : usuario.apellido, "uid" : usuario.getUid(), "userType" : "Doctor"])
            
            
            usuariosPacientes.remove(at: indexPath.row)
            
           // self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            usersCollection?.cleanInstance()
            usersCollection?.fetchPacientes()
            
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func editAction(_ sender: UIButton) {
        self.tableView.isEditing = !self.tableView.isEditing
        //sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detallesPacientesDoc") {
            let registrarPresion = segue.destination as! DetallesPacienteTableViewController
            let indice = tableView.indexPathForSelectedRow
            registrarPresion.userUID = usersCollection!.usuarios[usuariosPacientes[indice!.row]].uid
         }
        
    }
}
