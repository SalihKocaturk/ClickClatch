//
//  FeedViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 14.06.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage
class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView1.register(feedCell.self, forCellReuseIdentifier: "Cell")
       getdatafromfirestore()
        tableView1.delegate = self
        tableView1.dataSource = self
        // Do any additional setup after loading the view.
        getdatafromfirestore()
    }
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var usareImageArray = [String]()
    var documentIdArray = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    
    func getdatafromfirestore(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("posts").addSnapshotListener { snapshot, error in
            if error != nil{
                self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                
                
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.usareImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)

                    for document in snapshot!.documents{
                        let documentid = document.documentID
                        self.documentIdArray.append(documentid)
                        if let postedby = document.get("postedby") as? String{
                            self.userEmailArray.append(postedby)
                            print(postedby)
                            
                        }
                        if let postcomment = document.get("postcomment") as? String{
                            self.userCommentArray.append(postcomment)
                        }
                        if let imageurl = document.get("imageurl") as? String{
                            self.usareImageArray.append(imageurl)
                            
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                            
                        }
                    }
                    self.tableView1.reloadData()
                    
                    
                }
                
                
            }
            
        }
        
    }
    func makealert(titleInput:String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"okbutton", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert,animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
                cell.maillabel.text = userEmailArray[indexPath.row]
                cell.likeLabel.text = String(likeArray[indexPath.row])
                cell.commentlabel.text = userCommentArray[indexPath.row]
                cell.userİmageView.sd_setImage(with: URL(string: self.usareImageArray[indexPath.row]))
                
                return cell
    
         
        
        
             
               
             
        
    }

    @IBOutlet weak var tableView1: UITableView!
    
    


}
