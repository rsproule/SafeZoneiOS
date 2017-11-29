//
//  GroupListViewController.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class GroupListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupsArray: [Group] = [];
    var eventIdsArray: [[String]] = []
    var memberIdsArray: [[String]] = []
    
    let cellReuseIdentifier = "tablecell"

    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.groupTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        groupTableView.delegate = self;
        groupTableView.dataSource = self;
        
        
        
        getGroupsFromDatabase(userID: CURRENT_USER_ID)
        
        

        // Do any additional setup after loading the view.
    }

    
    // Table View Delagate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
       // let cell:UITableViewCell = self.groupTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "groupCell")
        }
        // set the text from the data model
        cell?.textLabel?.text = self.groupsArray[indexPath.row].groupName
        //cell?.detailTextLabel?.text = self.groupsArray[indexPath.row].members
        
        return cell!;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("Selected " + groupsArray[indexPath.row].groupName);

        self.performSegue(withIdentifier: "groupInfoSegue", sender: indexPath.row)

    }
    
    
    //Firebase stuff
    
    func getGroupsFromDatabase(userID: String){
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let currentUser = userID
        
        let usersGroupsRef = ref.child("users").child(currentUser).child("groups");

        
        // observes all the current user's groups
        usersGroupsRef.observe(.childAdded, with: {(snapshot)-> Void in
            
            let groupRef = ref.child("groups").child(snapshot.key);
            
            // do a JOIN by group ID
            groupRef.observe(.value, with: {(snap) -> Void in
                
                if let grp = snap.value as? Dictionary<String, AnyObject>{
                    
                    let name = grp["name"] as! String
                    let memberIds: [String] = self.parseMembers(membersDict: grp["members"]!);
                    let eventIds: [String] = self.parseEvents(eventsDict: grp["events"]!);
                    
                    let group = Group(name: name, members: [], events: [])
                    
                   
                    self.memberIdsArray.append(memberIds);
                    self.eventIdsArray.append(eventIds);
                    self.groupsArray.append(group);
                   
                    self.groupTableView.insertRows(at: [IndexPath(row: self.groupsArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                    
                    
                }else{
                    print("BAD DATA") // should avoid crash but IDK
                }
        
            })
         
        })
        
        
        
    }
    
    
    func parseMembers(membersDict: AnyObject) -> [String] {
        var users: [String] = [];
        
        let m = membersDict as! Dictionary<String, Any>
        for userId in m.keys {
            users.append(userId);
            
        }
    
        
        return users;
        
    }
    
    func parseEvents(eventsDict: AnyObject) -> [String] {
        var eventIds: [String] = [];
        
        let e = eventsDict as! Dictionary<String, Any>
        
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
        
        for id in e.keys {
            eventIds.append(id);
         
        }
      // print(events)
        return eventIds;
        
    }
    
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier ==  "groupInfoSegue" {
            let detailVC = segue.destination as! GroupInfoViewController
            detailVC.eventIds = eventIdsArray[sender as! Int];
            detailVC.memberIds = memberIdsArray[sender as! Int];
        }
    }
    

}



