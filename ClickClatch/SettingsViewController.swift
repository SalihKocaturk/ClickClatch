//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by salih kocatürk on 14.06.2023.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    
    
     @IBAction func logout(_ sender: Any) {
         do {
             try Auth.auth().signOut()
             self.performSegue(withIdentifier: "toVC", sender: nil)
         }catch{
             print("error")
         }
        
         
     }
     
    @IBAction func uploadphoto(_ sender: Any) {
        performSegue(withIdentifier: "toupp", sender: nil)
    }
    
    
}
