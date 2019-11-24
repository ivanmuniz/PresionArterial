//
//  MenuContainerViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 20/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit

class MenuContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func quitarMenu(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
