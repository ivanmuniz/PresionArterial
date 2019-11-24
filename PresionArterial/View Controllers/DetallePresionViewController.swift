//
//  DetallePresionViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 19/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase

class DetallePresionViewController: UIViewController {

    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var tfSistolica: UITextField!
    @IBOutlet weak var tfDiastolica: UITextField!
    @IBOutlet weak var tfPulso: UITextField!
    var user: Usuario! = Usuario.getInstance()
    let handler: DBHandler! = DBHandler()
    var presion: Presion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle Presión"
        displayInfo()
    }
    
    // Desplegar datos de presion actuales en los text fields
    func displayInfo() {
        lbFecha.text = presion.sTimeStamp
        tfSistolica.text = "\(presion.iSistolica!)"
        tfDiastolica.text = "\(presion.iDiastolica!)"
        tfPulso.text = "\(presion.iPulso!)"
    }
    
    @IBAction func guardarTapped(_ sender: UIButton) {
        if let diastolica = Int(tfDiastolica.text!),
            let sistolica = Int(tfSistolica.text!),
            let pulso = Int(tfPulso.text!) {        handler.getDB().collection("users").document(user.getUid()).collection("presion").document(presion.id).updateData(
                ["diastolica": diastolica,
                 "sistolica": sistolica,
                 "pulso": pulso,
                 "dateUpdated": Firebase.Timestamp()]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
            }
            navigationController?.popViewController(animated: true)
        } else {
            showAlert()
        }
    }
    
    func showAlert() -> Void {
        let alerta = UIAlertController(title: "Campos vacios", message: "Por favor ingrese todos los datos solicitados", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
}
