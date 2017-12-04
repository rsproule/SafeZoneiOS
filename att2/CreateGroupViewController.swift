//
//  CreateGroupViewController.swift
//  att2
//
//  Created by Ryan Sproule on 11/28/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var usersAddedLabel: UILabel!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createGroupButton(_ sender: Any) {
        let newGroup = Group(name: groupNameTextField.text!, members: newGroupMembers, events: [], id: "")
        
        if(newGroupMembers.count >= 1 && groupNameTextField.text != ""){
            // send new group to firebase for each member, then segue back to groups
            var membersJSON: [String: Any] = [:]
            
            for user in newGroupMembers{
                membersJSON[user.Id] = [
                    "name" : user.name,
                    "username" : user.username
                ]
            }
            
            membersJSON[CURRENT_USER.Id] = [
                "name" : CURRENT_USER.name,
                "username" : CURRENT_USER.username
            ]
            
            
           
            let groupDICT: [String: Any] = [
                "name" : newGroup.groupName,
                "members" : membersJSON,
                "events" : "Null"
            ]
           
            
           // let groupJSON = JSON(groupDICT)
            
            
           
            
            var ref: DatabaseReference?
            
            ref = Database.database().reference()
            
            let groupRef = ref?.child("groups").childByAutoId()
            
            let memberRef = ref?.child("users")
            
            
            
            groupRef?.setValue(groupDICT);
            
            for user in newGroupMembers {
               memberRef?.child(user.Id)
                .child("groups")
                .child((groupRef?.key)!)
                .setValue(true)
            }
            
            //Current 
            memberRef?.child(CURRENT_USER.Id)
            .child("groups")
            .child((groupRef?.key)!)
            .setValue(true)
            
            //segue createdGroup
            self.dismiss(animated: true, completion: nil)

            
            
            
            
            
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!

    var searchResultsUsers: [User] = [];
    var newGroupMembers: [User] = [];
    var filteredResults: [User] = [];
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self;
        
        getAllUsers();
        
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getAllUsers(){
        var ref: DatabaseReference
        
        ref = Database.database().reference().child("users");
        
        ref.observe(.childAdded, with: {(snap) -> Void in
            if let user = snap.value as? Dictionary<String, AnyObject>{
                let name = user["name"] as! String
                let username = user["username"] as! String
                let id = snap.key;
                
                if(id != CURRENT_USER.Id){
                    self.searchResultsUsers.append(User(name: name, Id: id, username: username))
                    self.filteredResults.append(User(name: name, Id: id, username: username))
                }
                self.searchResultsTableView.reloadData()
            }

        })
    
    
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

extension CreateGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
        }
        cell?.textLabel?.text = filteredResults[indexPath.row].name
        cell?.detailTextLabel?.text = filteredResults[indexPath.row].username
        return cell!
    }
    
    
}

extension CreateGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // on select add to list of users and then reset the search query
        let newUser = filteredResults[indexPath.row]
        searchResultsUsers.remove(at: indexPath.row)
        filteredResults.remove(at: indexPath.row)
        
        newGroupMembers.append(newUser)
        
        usersAddedLabel.text = "";
        var s: String = "";
        for u in newGroupMembers {
            s.append( u.name + ", ");
        }
        usersAddedLabel.text = s
        
        searchResultsTableView.reloadData()
        
    }
}

extension CreateGroupViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(filteredResults.count)
        
        let query = searchText.lowercased()
        if query.characters.count == 0 {
            filteredResults = searchResultsUsers;
        }else{
            filteredResults = searchResultsUsers.filter({(user) in
                
                if(user.name.lowercased().contains(query)){
                    return true;
                }
                
                if(user.username.lowercased().contains(query)){
                    return true;
                }
                
                return false;
            })
            print(filteredResults.count)
            
            self.searchResultsTableView.reloadData()
        }
    }
    
}

extension CreateGroupViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        
    }
}



