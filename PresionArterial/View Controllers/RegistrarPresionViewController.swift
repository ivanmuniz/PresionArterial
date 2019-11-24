//
//  RegistrarPresionViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 14/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol protocolDataAdded {
    func dataAdded()
}

class RegistrarPresionViewController: UIViewController {
    @IBOutlet weak var tfSistolica: UITextField!
    @IBOutlet weak var tfDiastolica: UITextField!
    @IBOutlet weak var tfPulso: UITextField!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var lbCounter: UILabel!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    var isTimerRunning = false
    var resumeTapped = false
    var count = 0
    var timer = Timer()
    
    let handler: DBHandler! = DBHandler()
    let usuario: Usuario! = Usuario.getInstance()
    var delegate: protocolDataAdded!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registrar Presión"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM/yyy"
        let date = Date()
        let result = formatter.string(from: date)
        lbTime.text = result
        btnPause.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func guardarTapped(_ sender: UIButton) {
        if let iSistolica = Int(tfSistolica.text!),
            let iDiastolica = Int(tfDiastolica.text!),
            let iPulso = Int(tfPulso.text!) {
            // Todos los datos estan escritos
            // Guardar datos en firebase
            registerRecord(iSistolica: iSistolica, iDiastolica: iDiastolica, iPulso: iPulso)
        } else {
            // Falta un dato
            // Mostrar alerta de que falta un dato
            showAlert()
        }
    }
    
    func showAlert() -> Void {
        let alerta = UIAlertController(title: "Campos vacios", message: "Por favor ingrese todos los datos solicitados", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    func registerRecord(iSistolica: Int, iDiastolica: Int, iPulso: Int) -> Void {
        let presionData: [String: Any] = [
            "dateAdded": Firebase.Timestamp(),
            "sistolica": iSistolica,
            "diastolica": iDiastolica,
            "pulso": iPulso
        ];
        handler.getDB().collection("users").document(usuario.getUid()).collection("presion").addDocument(data: presionData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func counter() {
        count += 1
        lbCounter.text = timeString(time: TimeInterval(count))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
        isTimerRunning = true
        btnPause.isEnabled = true
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            btnStart.isEnabled = false
        }
    }
    
    @IBAction func pausePressed(_ sender: UIButton) {
        if resumeTapped == false {
            timer.invalidate()
            resumeTapped = true
            btnPause.setTitle("Resumir", for: .normal)
        } else {
            runTimer()
            resumeTapped = false
            btnPause.setTitle("Detener", for: .normal)
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        timer.invalidate()
        count = 0
        lbCounter.text = "00:00:00"
        isTimerRunning = false
        btnPause.isEnabled = false
        btnStart.isEnabled = true
    }

}
