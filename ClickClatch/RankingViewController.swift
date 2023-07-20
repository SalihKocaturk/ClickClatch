//
//  RankingViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 17.07.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
class HighScore{
    var highscorevalue = 0
    var userEmail = ""
    init(highscorevalue: Int = 0, userEmail: String = "") {
        self.highscorevalue = highscorevalue
        self.userEmail = userEmail
    }
    init(){
        
        
    }
}
class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var documentidarray = [String]()
    var highscoreArray = [HighScore]()
    var i:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getdatafromfirestore()
    }
    func getdatafromfirestore(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("posts").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        
                        
                        if let madeBy = document.get("madeby") as? String, let highscorev = document.get("highscore") as? Int {
                            
                            let highscore = HighScore(highscorevalue: highscorev, userEmail: madeBy )
                            self.highscoreArray.append(highscore)
                            
                            
                         }
                         
                            
                        
                        
                    }
                    self.highscoreArray.sort{
                        
                        $0.highscorevalue > $1.highscorevalue
                        
                    }
                    self.tableView.reloadData()
                    self.tableView.backgroundColor = .white
                    print(self.highscoreArray)
                    
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("lol")
        return highscoreArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("allllll")
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text =  "\(highscoreArray[indexPath.row].highscorevalue) \(highscoreArray[indexPath.row].userEmail)"
        cell.contentConfiguration = content
        return cell
    }
   
  

}
