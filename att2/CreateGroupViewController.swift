//
//  CreateGroupViewController.swift
//  att2
//
//  Created by Ryan Sproule on 11/28/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBAction func createGroupButton(_ sender: Any) {
        let newGroup = Group(name: groupNameTextField.text!, members: newGroupMembers, events: [])
        
        // send new group to firebase for each member
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)

    var searchResultsUsers: [User] = [];
    var newGroupMembers: [User] = [];
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self;
        
        getAllUsers();
        
        //searchCompleter.delegate = self;
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        //navigationItem.searchController = searchController
        definesPresentationContext = true
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
                
                self.searchResultsUsers.append(User(name: name, Id: id, username: username))
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
        return searchResultsUsers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
        }
        cell?.textLabel?.text = searchResultsUsers[indexPath.row].name
        cell?.detailTextLabel?.text = searchResultsUsers[indexPath.row].username
        return cell!
    }
    
    
}

extension CreateGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // on select add to list of users and then reset the search query
    }
}

extension CreateGroupViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}



