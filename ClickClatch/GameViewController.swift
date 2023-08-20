//
//  GameViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 17.07.2023.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseCore
import SDWebImage
class Photos{
    var photoid = ""
    var postedby = ""
    var place = 0
    init(photoid: String = "", postedby: String = "", place: Int = 0) {
        self.photoid = photoid
        self.postedby = postedby
        self.place = place
    }
    
}
class GameViewController: UIViewController {
    var timer = Timer()
    var counter = 0
    var score = 0
    var hideTimer = Timer()
    var highScore = 0

    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var specifyButton: UIButton!
    @IBOutlet weak var image9: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var imageArray = [UIImageView]()
    var newImageId = ""
    var documentidarray = [String]()
    var userArray = [String]()
    var photoArray = [Photos]()
    var a = "\(Auth.auth().currentUser)"
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        if image1.image != UIImage(named: "select.png"){
            errorLabel.isHidden = true
            
        }
        specifyButton.isHidden = false
        imageArray = [image1,image2,image3,image4,image5,image6,image7,image8,image9]
        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        image4.isUserInteractionEnabled = true
        image5.isUserInteractionEnabled = true
        image6.isUserInteractionEnabled = true
        image7.isUserInteractionEnabled = true
        image8.isUserInteractionEnabled = true
        image9.isUserInteractionEnabled = true
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(IncreaseScore))
        image1.addGestureRecognizer(recognizer1)
        image2.addGestureRecognizer(recognizer2)
        image3.addGestureRecognizer(recognizer3)
        image4.addGestureRecognizer(recognizer4)
        image5.addGestureRecognizer(recognizer5)
        image6.addGestureRecognizer(recognizer6)
        image7.addGestureRecognizer(recognizer7)
        image8.addGestureRecognizer(recognizer8)
        image9.addGestureRecognizer(recognizer9)
        
        hideallimage()
        changeallpics()
    }
    func changeallpics(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("uploadedPhoto").addSnapshotListener { snapshot, error in
            if error != nil{
                self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                
            }else{
                
                if snapshot?.isEmpty == false{
                    self.photoArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        var i = 0
                        
                        if let postedBy = document.get("postedby") as? String, let imageUrl = document.get("imageurl") as? String, let np = document.get("imagePlace") as? Int{
                            print("abc")
                            print(imageUrl)
                            let phototos = Photos(photoid: imageUrl, postedby: postedBy,place: np)
                            self.photoArray.append(phototos)
                        
                            
                            
                          
                        }
                    }
                    if self.photoArray.count != 0{
                        var i = 0
                        var k = 1
                        var theplacement = 0
                        var a = Int(self.photoArray.count)
                        
                        for array in self.photoArray {
                            if self.photoArray[i].place > k {
                                k = self.photoArray[i].place
                                theplacement = i
                                i += 1
                            }
                            
                        }
                        for image in self.imageArray {
                            
                            image.sd_setImage(with: URL(string: self.photoArray[i].photoid))
                            
                        }
                    }else{
                        
                    }
                }
                
                
            }
        }
        
    }
    @objc func hideallimage(){
        for image in imageArray{
            image.isHidden = true
           
        }
        specifyButton.isHidden = false
    }
    @objc func hideimage(){
        for image in imageArray{
            image.isHidden = true
           
        }
        let random = Int(arc4random_uniform(UInt32(imageArray.count-1)))
        imageArray[random].isHidden = false
    }
    @objc func IncreaseScore(){
        score = score + 1
        scoreLabel.text = "score: \(score)"
       
        
    }
    @objc func timerfunc(){
        
        
            
        
            
            timeLabel.text = "Time: \(counter)"
                        counter -= 1
                        
                       
        
        if counter == 0 {
          
            timer.invalidate()
            hideTimer.invalidate()
            
            if self.score > self.highScore{
                self.highScore = self.score
                highscoreLabel.text = "Highest Score :\(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            
            let storage = Storage.storage()//depolama alanını tanımlıyoruz
            let storagereference = storage.reference()
            let mediaFolder = storagereference.child("media")//media kademesini referans alıyoruz
            let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
            var firestorereferenc: DocumentReference? = nil//r
            let firestorepost = ["highscore":highScore ,"madeby":Auth.auth().currentUser!.email] as [String : Any]
            firestorereferenc = firestoreDatabase.collection("posts").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
                if error != nil{
                    self.makealert(titleInput: "error", messageInput:error?.localizedDescription ?? "error" )
                    
                }else{
                    
                    
                    self.tabBarController?.selectedIndex = 0
                }
                
            })
            let alert = UIAlertController(title: "game is over", message: "your time is over", preferredStyle: UIAlertController.Style.alert)
            let replayButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) {(UIAlertAction)in
                self.hideallimage()
            }
                        
                        
                            let okButton = UIAlertAction(title: "try again", style: UIAlertAction.Style.default){(UIAlertAction) in
                                
                                self.counter = 10
                                self.score = 0
                                self.scoreLabel.text = "score:\(self.score)"
                                self.timeLabel.text = "\(self.counter)"
                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerfunc), userInfo: nil, repeats: true)
                                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideimage), userInfo: nil, repeats: true)
                                self.specifyButton.isHidden = true
                                
                            }
                               alert.addAction(replayButton)
                               alert.addAction(okButton)
                            self.present(alert , animated: true)
                           
                        }
            
            
        
   
        
        
        
        
    }
    
    @IBAction func playButton(_ sender: Any) {
        self.counter = 10
        self.score = 0
        self.scoreLabel.text = "score:\(self.score)"
        self.timeLabel.text = "\(self.counter)"
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerfunc), userInfo: nil, repeats: true)
        self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideimage), userInfo: nil, repeats: true)
        self.specifyButton.isHidden = true
    }
    func makealert(titleInput:String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"okbutton", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert,animated: true, completion: nil)
        
    }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


