//
//  UploadViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 14.06.2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
   var npArray = [Int]()
    var a = 0
    var documentidarray = [String]()
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(savephoto))
        imageView.addGestureRecognizer(imageTapRecognizer)
       
    }
    func getTheA(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("uploadedPhoto").addSnapshotListener { snapshot, error in
            if error != nil{
                self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                
            }else
            {
                if snapshot?.isEmpty == false{
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        var i = 0
                        var x = -1
                        if let np = document.get("imagePlace") as? Int{
                            print("np")
                            print(np)
                            self.npArray.append(np)
                            for array in self.npArray {
                                if self.npArray[i] > x{
                                    x = self.npArray[i]
                                    
                                }
                                
                            }
                            self.a = self.npArray.count + 1
                            print(self.a)
                            
                            
                          
                        }else
                        {
                          
                        }
                    }
                }
            }
            
            
            
            
        }
    }

    @IBAction func saveButton(_ sender: Any) {
    
        let storage = Storage.storage()//depolama alanını tanımlıyoruz
        let storagereference = storage.reference()
        let mediaFolder = storagereference.child("media")//media kademesini referans alıyoruz
        if let data = imageView.image?.jpegData(compressionQuality: 0.75){//data kaydetme
            let uuid = UUID().uuidString
            let imagereference = mediaFolder.child("\(uuid).jpg")//rastgele idnin referansını atıyoruz
            imagereference.putData(data,metadata: nil) { metadata, error in //datayı uploadlama
                if error != nil{
                    self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                    
                    
                }else{
                    imagereference.downloadURL { (url, error) in//urlyi indiriyoruz
                        if error == nil{
                            self.getTheA()
                            print(self.a)
                            let imageUrl = url?.absoluteString//stringe çeviriyoruz
                            let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
                            var firestorereferenc: DocumentReference? = nil//referans tanımlıyoruz
                            let firestorepost = ["imageurl": imageUrl!,"postedby":Auth.auth().currentUser!.email,"imagePlace":self.a] as [String : Any]//postun değerlerini giriyoruz
                            
                            firestorereferenc = firestoreDatabase.collection("uploadedPhoto").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
                                if error != nil{
                                    self.makealert(titleInput: "error", messageInput:error?.localizedDescription ?? "error" )
                                    
                                }else{
                                    self.imageView.image = UIImage(named: "select")//fee dekranına geçiş yapılacak
                                    self.makealert(titleInput: "succed", messageInput: "succsesfully done")
                                    self.tabBarController?.selectedIndex = 0
                                }
                                
                            })
                            
                            
                        }
                    }
                    
                }
            }
       
            
        }
            }
   
    
    @objc func savephoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func makealert(titleInput:String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default){(UIAlertAction) in
            self.performSegue(withIdentifier: "tosett", sender: nil)
        }
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
        
    }

}
