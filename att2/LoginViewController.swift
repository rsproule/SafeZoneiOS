//
//  LoginViewController.swift
//  att2
//
//  Created by Ryan Sproule on 11/22/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase


class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logInButton(_ sender: UIButton) {

        let username: String = usernameTextField.text!;

        if username == "" {
            // do nothing but notify user
            errorText.text! = "No Username Entered"
        }
        else{
            //check if its in Firebase
            let ref : DatabaseReference!
            ref = Database.database().reference()
            
            let loginRef = ref.child("logins");
            
            
            loginRef.observe(.value, with: {(snap) -> Void in
                
                let users = snap.value as! Dictionary<String, String>
                if users[username] == nil {
                    self.errorText!.text = "Invalid Username"
                }else{
                    // SET THE GLOBAL USER
                    CURRENT_USER_ID = users[username]!;
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            })
            
        }
      
        
        
    }
    
    
    
    
    
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
//        let destVC = segue.destination as! MainTabBarController;
//        destVC.currentUserId = self.userId
//    }
 

}
