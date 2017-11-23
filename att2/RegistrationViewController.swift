//
//  RegistrationViewController.swift
//  
//
//  Created by Ryan Sproule on 11/22/17.
//

import UIKit
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        // TODO Make sure the user actually want to leave
        
        self.performSegue(withIdentifier: "cancelRegistration", sender: self)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        let username: String = usernameTextField.text!;
        let name: String = nameTextField.text!;
    
        //make sure theres something there
        if(username != "" && name != ""){
            
            //check if the username entered is already in Firebase
            let ref : DatabaseReference!
            ref = Database.database().reference()
            
            let loginRef = ref.child("logins");
            
            
            loginRef.observe(.value, with: {(snap) -> Void in
                
                let users = snap.value as! Dictionary<String, String>
                if users[username] == nil {
                    // good to upload
                    self.registerUser(name: name, username: username)
                }else{
                    // this guy is already taken, report in error text somewhere
                    
                }
            })
        }
    }
    
    func registerUser(name : String, username: String){
        let ref: DatabaseReference!
        
        ref = Database.database().reference();
        
        let newUserRef = ref.child("users").childByAutoId();
        
        newUserRef.setValue([
            "name" : name,
            "username" : username
        ])
        
        let newKey = newUserRef.key;
        
        let loginRef = ref.child("logins");
        
        loginRef.child(username).setValue(newKey);
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
