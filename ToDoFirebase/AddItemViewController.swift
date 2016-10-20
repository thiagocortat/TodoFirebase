//
//  AddItemViewController.swift
//  ToDoFirebase
//
//  Created by Thiago Cortat on 12/10/16.
//  Copyright © 2016 Infnet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddItemViewController: UIViewController,
                    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref:FIRDatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    var key:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let key = key {
            ref = FIRDatabase.database().reference().child("items").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapShot) in
                
                var dic = snapShot.value as! [String: String]
                self.tfTitle.text = dic["title"]
                self.txtDescription.text = dic["description"]
                if let imageUrl = dic["imageUrl"] {
                    self.imageView.loadImageWithCache(imageUrl)
                }
            })
        }else {
            ref = FIRDatabase.database().reference().child("items").childByAutoId()
        }
    }

    @IBAction func btnSave(_ sender: AnyObject) {
        
        var dic = ["title":tfTitle.text!, "description": txtDescription.text!]

        //Verifica se o usário inseriu uma imagem e converse para o tipo Data
        if let data = self.imageView.image, let imageData = UIImageJPEGRepresentation(data, 0.5) {
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://todo-e31cc.appspot.com")
            let imageName = UUID().uuidString //Cria uma nova string única toda vez que é chamada
            let spaceRef = storageRef.child("images/\(imageName).jpg")
            spaceRef.put(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("ERRO -> Imagem não foi Salva!")
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    dic["imageUrl"] = imageUrl
                    self.registerItem(dic)
                }
            }
        }
        else {
            self.registerItem(dic)
        }
    }
    
    //Função que salva o Item no Firebase e limpa os campos
    func registerItem(_ dic:[String:String]) {
        
        ref.setValue(dic)
        
        //Limpa os valores nos compomentes
        self.tfTitle.text = ""
        self.txtDescription.text = ""
        self.imageView.image = nil
        self.showAlert()
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Infnet ToDo",
                                      message: "Item Adicionado com sucesso",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnGetImage(_ sender: AnyObject) {
        
        //Instancia o Controller de Imagens
        let picker = UIImagePickerController()
        
        //Diz que irá implementar os protocolos
        picker.delegate = self
        
        //Permite Editar a imagem
        picker.allowsEditing = true
        
        //Tipo da fonte da imagem
        picker.sourceType = .photoLibrary 
        
        //Atribui ao controlador corrent
        self.present(picker, animated: true, completion: nil)
        
    }
    
    //Chamado quando o usuário seleciona uma Imagem
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = editImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Chamado quando o usuário seleciona o botão de Cancelar
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}




////Pega imagem a partir da Camera
//picker.sourceType = .camera
//
////Pega imagem a partir da Galeria
//picker.sourceType = .photoLibrary
//
////Pega imagem a partir do PhotoAlbum (Camera Roll)
//picker.sourceType = .savedPhotosAlbum



