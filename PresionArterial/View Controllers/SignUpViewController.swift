//
//  SignUpViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 13/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var scPacienteDoctor: UISegmentedControl!
    @IBOutlet weak var btnRegistrarse: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registrarse"
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        lbError.alpha = 0
        Utilities.styleTextField(tfNombre)
        Utilities.styleTextField(tfApellido)
        Utilities.styleTextField(tfCorreo)
        Utilities.styleTextField(tfPassword)
        Utilities.styleFilledButton(btnRegistrarse)
    }
    
    // Check the fields and validate if the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in
        if tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Por favor llene todos los campos."
        }
        
        // Check if the password is secure
        let cleanedPassword = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Por favor verifique que su contraseña tenga al menos 8 caracteres, un caracter especial y un numero."
        }
        
        return nil
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        // Validate fields
        var userType : String = ""
        if scPacienteDoctor.selectedSegmentIndex == 1{
            userType = "Doctor"
        }
        else{
            userType = "Paciente"
        }
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let firstName = tfNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = tfApellido.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    // There was an error
                    print(err?.localizedDescription as Any)
                    self.showError("Error al crear el usuario.")
                }
                else {
                    // User was created successfully
                    let db = Firestore.firestore()
                   
                    db.collection("users").document(result!.user.uid).setData(["firstName" : firstName, "lastName" : lastName, "userType" : userType, "uid" : result!.user.uid], completion: { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error guardando la información del usuario.")
                        }
                    })
                    // Transition to home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message: String) {
        lbError.text = message
        lbError.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard!.instantiateViewController(withIdentifier: Constants.Storyboard.doctorOrPaciente) 
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
