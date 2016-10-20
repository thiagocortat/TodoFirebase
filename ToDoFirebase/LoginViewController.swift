//
//  LoginViewController.swift
//  ToDoFirebase
//
//  Created by Thiago Cortat on 12/10/16.
//  Copyright © 2016 Infnet. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnEnter(_ sender: AnyObject) {
        
        FIRAuth.auth()?.signIn(withEmail: tfEmail.text!, password: tfPassword.text!, completion: { (user, error) in
            if error != nil {
                print("Erro, não foi possivel criar usário")
            }else{
                print("Usuário criado com sucesso!")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        })
    }

}



