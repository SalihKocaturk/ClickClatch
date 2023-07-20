//
//  ViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 13.06.2023.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
class ViewController: UIViewController {
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*let currentuser = Auth.auth().currentUser
         if currentuser != nil {
         self.performSegue(withIdentifier: "toFeedVC", sender: nil)
         
         
         }
         *///scenedelegateda windowun altında tanımlayacağız
    }
    
    @IBAction func aignin(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
        if usernameText.text != "" && passwordText.text != ""{ //kullanıcı oluşturma
            
            Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!){
                (authdata,error) in
                if error != nil{
                    self.makealert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                    
                }
            }
            
        }else{
            makealert(titleInput: "Error", messageInput: "Username/ Password??")
            
            
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: usernameText.text!, password: passwordText.text!){(authdata, error) in
                if error != nil{
                    self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                    
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
            
        }else{
            makealert(titleInput: "Error", messageInput: "Username/ Password??")
            
            
        }
    }
    func makealert(titleInput:String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"okbutton", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert,animated: true, completion: nil)
        
    }
    
    @IBAction func SignINWGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential)
          performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
    }
    
}

