//
//  HomeT2ViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 16/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeT2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, protocolDataFetched, protocolDataAdded {
    
    func dataReady() {
        tableView.reloadData()
    }
    
    func dataAdded() {
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnLogout: UIBarButtonItem!
    let alturaCelda: CGFloat! = 95.00
    let usuario: Usuario! = Usuario.getInstance()
    let db = DBHandler().getDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Presión"
        tableView.tableFooterView = UIView()
        usuario.delegate = self
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.frame.size.width
        btnAdd.layer.masksToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(usuario.presion.count)
        return usuario.presion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PresionT2TableViewCell
        cell.lbDiastolica.text = "\(usuario.presion[indexPath.row].iDiastolica!)"
        cell.lbSistolica.text = "\(usuario.presion[indexPath.row].iSistolica!)"
        cell.lbPulso.text = "\(usuario.presion[indexPath.row].iPulso!)"
        cell.lbFecha.text = usuario.presion[indexPath.row].sTimeStamp
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return alturaCelda
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "registrar_presion") {
             let registrarPresion = segue.destination as! RegistrarPresionViewController
             registrarPresion.delegate = self
         }
        else if (segue.identifier == "detalle_presion") {
            let indice = tableView.indexPathForSelectedRow!
            let detallePresion = segue.destination as! DetallePresionViewController
            detallePresion.presion = usuario.presion[indice.row]
        }
        else if (segue.identifier == "menu") {
            print("menu")
        }
    }
}
