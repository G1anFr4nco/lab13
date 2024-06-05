//
//  crearUsuarioViewController.swift
//  mamaniSaycoSnapchat2
//
//  Created by Gian Mamani on 29/05/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class crearUsuarioViewController: UIViewController {

    @IBOutlet weak var emailCrear: UITextField!
    @IBOutlet weak var contrasenaCrear: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func crearUsuarioTapped(_ sender: Any) {
        guard let email = emailCrear.text, let password = contrasenaCrear.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Manejo del error
                let alerta = UIAlertController(title: "Error", message: "Se presentó el siguiente error al crear el usuario: \(error.localizedDescription)", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
                return
            }
            
            // Usuario creado exitosamente
            Database.database().reference().child("usuarios").child(authResult!.user.uid).child("email").setValue(authResult!.user.email)
            
            let alerta = UIAlertController(title: "Usuario creado", message: "Se creó el usuario con éxito", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "usuariocreado", sender: nil)
            })
            alerta.addAction(btnOK)
            self.present(alerta, animated: true, completion: nil)
        }
    }
}
