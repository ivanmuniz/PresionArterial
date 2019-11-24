//
//  ViewController.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 11/10/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBLoginButton!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var lbError: UILabel!
    let LOG = "D:"
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    
        if ((error) != nil) {
            // Process error
            print(LOG, "Error! : \(error!.localizedDescription)")
            return
            
        }
        else if result!.isCancelled {
            // Handle cancellations
            print(LOG, "Success! : user cancel login request")
            return
        }
        else {
            print(LOG, "User logged in!")
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) {
                (authResult, error) in
                    if let error = error {
                        print(self.LOG, "Error! : \(error.localizedDescription)")
                        return
                    }
                }
            print(LOG, "Firebase signed in")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print(LOG, "User logged out!")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print (LOG, "Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // No user is signed in.
        title = "Iniciar Sesión"
        setUpElements()
        //        let loginButton = FBLoginButton(frame: .init(x: 0, y: 0, width: 300, height: 50), permissions: [.publicProfile])
        loginButton.permissions = ["public_profile"];
        loginButton.delegate = self
    }
    
    func setUpElements() {
        Utilities.styleTextField(tfCorreo)
        Utilities.styleTextField(tfPassword)
        Utilities.styleFilledButton(btnIniciarSesion)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // Validate text fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            // Login the user
            let email = tfCorreo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (reuslt, error) in
                if error != nil {
                    self.lbError.text = error!.localizedDescription
                    self.lbError.alpha = 1
                }
                else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome() {
        //let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeT2ViewController) as! UINavigationController
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.doctorOrPaciente)
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if tfCorreo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Por favor llene todos los campos."
        }
        return nil
    }
    
    func showError(_ message: String) {
        lbError.text = message
        lbError.alpha = 1
    }
    
}

