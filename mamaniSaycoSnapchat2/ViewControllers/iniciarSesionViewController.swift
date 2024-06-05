//
//  ViewController.swift
//  mamaniSaycoSnapchat2
//
//  Created by Gian Mamani on 22/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGoogleSignIn()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if let error = error {
                print("Se presentó el siguiente error: \(error)")
                
                // Mostrar alerta de usuario no existente
                let alerta = UIAlertController(title: "El usuario no existe", message: "Primero cree el usuario \(self.emailTextField.text!). ¿Quiere crearlo? ", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear", style: .default, handler: {_ in
                    self.performSegue(withIdentifier: "crearUsuarioSegue", sender: nil)
                })
                let btnCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                alerta.addAction(btnOK)
                alerta.addAction(btnCancel)
                self.present(alerta, animated: true, completion: nil)
                
            } else {
                print("Inicio de Sesion Exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    func configureGoogleSignIn() {
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    if let error = error {
                        print("Error de sesion antigua: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let user = user else { return }
                    
                    let idToken = user.idToken?.tokenString
                    let accessToken = user.accessToken.tokenString
                    
                    guard let idTokenString = idToken else { return }
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idTokenString, accessToken: accessToken)
                    
                    Auth.auth().signIn(with: credential) { result, error in
                        if let error = error {
                            print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                            return
                        }
                        print("Inicio con Google correcto!")
                    }
                }
            }
    
    @IBAction func buttonLoginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString
            
            guard let idTokenString = idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idTokenString, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                    return
                }
                print("Inicio con Google correcto!")
            }
        }
    }
}
