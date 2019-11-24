//
//  PerfilUsuarioViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 19/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PerfilUsuarioViewController: UIViewController {
    
    var usuario: Usuario! = Usuario.getInstance()
    let handler = DBHandler()
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var tfPeso: UITextField!
    @IBOutlet weak var tfEdad: UITextField!
    @IBOutlet weak var tfCircAbd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
    }
    
    func displayInfo() {
        let sPeso = usuario.peso != nil ? "\(usuario.peso!)" : ""
        let sEdad = usuario.edad != nil ? "\(usuario.edad!)" : ""
        let sCircAbd = usuario.circAbd != nil ? "\(usuario.circAbd!)" : ""
        tfNombre.text = usuario.nombre
        tfApellido.text = usuario.apellido
        tfEmail.text = Auth.auth().currentUser?.email
        tfEmail.isEnabled = false
        tfTelefono.text = usuario.telefono
        tfPeso.text = sPeso
        tfEdad.text = sEdad
        tfCircAbd.text = sCircAbd
    }
    
    @IBAction func quitaTeclado(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func guardarTapped(_ sender: UIButton) {
        if let nombre = tfNombre.text,
            let apellido = tfApellido.text,
            let telefono = tfTelefono.text,
            let peso = Int(tfPeso.text!),
            let edad = Int(tfEdad.text!),
            let circAbd = Int(tfCircAbd.text!) {
        handler.getDB().collection("users").document(usuario.getUid()).updateData(
                ["firstName": nombre,
                 "lastName": apellido,
                 "telefono": telefono,
                 "peso": peso,
                 "edad": edad,
                 "circAbd": circAbd]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        self.showAlert(title: "Error al guardar datos", message: "Por favor verifique su conección a internet")
                    } else {
                        print("Document successfully updated")
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        } else {
            showAlert(title: "Campos vacios", message: "Por favor ingrese todos los datos solicitados")
        }
    }
    
    func showAlert(title: String, message: String) -> Void {
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
}
