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
    
    let cellReuseIdentifier = "tablecell"

    
    // Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

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

        let cell:UITableViewCell = self.groupTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.groupsArray[indexPath.row].groupName
        
        return cell;
        
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
                    let members: [User] = self.parseMembers(membersDict: grp["members"]!);
                    let events: [Event] = self.parseEvents(eventsDict: grp["events"]!);
                    
                    
                    let group = Group(name: name, members: members, events: events)
                    
                    self.groupsArray.append(group);
                    self.groupTableView.insertRows(at: [IndexPath(row: self.groupsArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                    
                    
                }else{
                    print("BAD DATA") // should avoid crash but IDK
                }
        
            })
         
        })
        
        
        
    }
    
    
    func parseMembers(membersDict: AnyObject) -> [User] {
        var users: [User] = [];
        
        let m = membersDict as! Dictionary<String, Any>
        for username in m.keys {
            users.append(User(name: username));
        }
        
        return users;
        
    }
    
    func parseEvents(eventsDict: AnyObject) -> [Event] {
        var events: [Event] = [];
        
        let e = eventsDict as! Dictionary<String, Any>
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        for k in e.keys {
            let eventsRef = ref.child("events").child(k);
            
            eventsRef.observe(.value, with: {(snap) -> Void in
                if let eventInfoDict = snap.value as? Dictionary<String, Any> {
                    let eventName = eventInfoDict["name"] as! String
                    let loc: LocationPoint = self.parseLocation(locationDict: eventInfoDict["location"]!)
                    
                    let date: Date = Date(timeIntervalSince1970: eventInfoDict["date"] as! Double)

                    events.append(Event(location: loc, name: eventName, date: date))
                    
                }else{
                    print("Casting ERROR")
                }
                
            })
            
        }
       
        return events;
        
    }
    
    func parseLocation(locationDict: Any) -> LocationPoint{
        
        let loc = locationDict as! Dictionary<String, Any>
        
        let latitude = loc["latitude"] as! Double
        let longitude = loc["longitude"] as! Double
        let name = loc["name"] as! String
        let coord = CLLocationCoordinate2DMake(latitude, longitude)
        
        return LocationPoint(title: "Event Location", locationName: name, coordinate: coord)
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



