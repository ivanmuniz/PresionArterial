//
//  StartViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 13/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var btnRegistrarse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio"
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(btnIniciarSesion)
        Utilities.styleHollowButton(btnRegistrarse)
    }

}
