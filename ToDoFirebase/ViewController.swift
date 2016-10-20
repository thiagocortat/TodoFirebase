//
//  ViewController.swift
//  ToDoFirebase
//
//  Created by Thiago on 9/26/16.
//  Copyright © 2016 Infnet. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref:FIRDatabaseReference!
    var items: [[String:String]] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = FIRAuth.auth()?.currentUser {
            print("Usuário \(user.email) Logado")
            
            ref = FIRDatabase.database().reference().child("items")
            startingObserveDB()
        }
        else {
            //Não existe usuário registrado. Abrir tela de Login
            performSegue(withIdentifier: "LOGIN", sender: nil)
        }
    }
    
    @IBAction func btnLogout(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        performSegue(withIdentifier: "LOGIN", sender: nil)
    }
    
    func startingObserveDB() {
        ref.observe(.value) { (snapshot:FIRDataSnapshot) in
            var temp: [[String:String]] = []
            let enumerator = snapshot.children
            while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                
                var dic = item.value as! [String: String]
                dic["key"] = item.key
                temp.append(dic)
            }
            self.items = temp
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EDIT", let index = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! AddItemViewController
            var dic = self.items[index.row]
            detailVC.key = dic["key"]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fireCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item["title"]
        return cell
    }
    
    
}





//
//
//        ref.child("records").observeSingleEventOfType(.Value, withBlock: { snapshot in
//            // success block is not called
//            }, withCancelBlock: { error in
//                // cancel block triggered with PERMISSION_DENIED
//        })

