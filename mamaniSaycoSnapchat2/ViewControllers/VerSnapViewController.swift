//
//  VerSnapViewController.swift
//  mamaniSaycoSnapchat2
//
//  Created by Gian Mamani on 5/06/24.
//

import UIKit
import SDWebImage
import Firebase

class VerSnapViewController: UIViewController {

    
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)

        // Do any additional setup after loading the view.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
    }

}
