//
//  HomeViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 13/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, protocolDataFetched, protocolPacientesFetched{
    func reloadTableView() {
        
        
        
    }
    
    
    func dataReady() {
        transition()
    }
    
    var usuario = Usuario.getInstance()
        let usersCollection = UserCollection.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.usuario.setUid(uid: Auth.auth().currentUser!.uid)
                self.usuario.delegate = self
                self.usuario.fetchUserData()
            } else {
                // No user is signed in.
                let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as! UINavigationController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        usersCollection.delegatePacientesFetched = self
        usersCollection.fetchPacientes()
    }
    
    func transition() {
        if (usuario.userType == "Paciente") {
            //Si es paciente va a la primer pantalla del paciente
            let pacienteViewController = storyboard!.instantiateViewController(withIdentifier: Constants.Storyboard.pacienteHome) as! UINavigationController
            view.window?.rootViewController = pacienteViewController
            view.window?.makeKeyAndVisible()
        } else if (usuario.userType == "Doctor") {
            let doctorViewController = storyboard!.instantiateViewController(withIdentifier: Constants.Storyboard.doctorHome) as! UINavigationController
            view.window?.rootViewController = doctorViewController
            view.window?.makeKeyAndVisible()
        }
    }
    
}
