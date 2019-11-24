//
//  MenuViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 19/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UITableViewController {

    var usuario = Usuario.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Editar perfil")
            break
        
        case 1:
            print("Graficas")
            break
        case 2:
            print("Cerrar sesion")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                if let storyboard = self.storyboard {
                    let homeViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as! UINavigationController
                    view.window?.rootViewController = homeViewController
                    view.window?.makeKeyAndVisible()
                    usuario.cleanInstance()
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            break
        default:
            print("Default")
            break
        }
    }
}
