//
//  GroupInfoViewController.swift
//  att2
//
//  Created by Ryan Sproule on 11/28/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit


class CurrentInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    


    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var memberTableView: UITableView!

    
    var group: Group = Group();
    var groupLocation = CLLocation()
    

    var memberIds: [String] = []
    var memberCoords: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameLabel.text = group.groupName;
        
        memberTableView.delegate = self
        memberTableView.dataSource = self;
        //memberTableView.register(UITableViewCell.self, forCellReuseIdentifier: "memberCell")
        getMemberIds(userID: CURRENT_USER.Id)
        self.memberTableView.reloadData()
        //getMemberInfo(memberIds: self.memberIds)
    }
    
    func getMemberIds(userID: String){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let currentUser = userID
        
        let currEvRef = ref
            .child("users")
            .child(currentUser)
            .child("activeEvent");
        
        
        currEvRef.observe(.value, with: {(snapshot)-> Void in
            let currEvent = snapshot.value
            
            let eventRef = ref.child("events").child(currEvent as! String)
            
            eventRef.observe(DataEventType.value, with: {(snap) -> Void in
                if let event = snap.value as? Dictionary<String, Any> {
                    let mems = event["members"] as! Dictionary<String, Any>
                    let loc = event["location"] as! Dictionary<String, Any>
                    self.groupLocation = CLLocation(
                        latitude: loc["latitude"] as! Double,
                        longitude: loc["longitude"] as! Double
                    )
                    
                    var dist = 0.0
                    for (_, v) in mems {
                        let mem = v as! Dictionary<String, Any>
                        let fullname = mem["name"] as! String
                        let username = mem["username"] as! String
                        if let loc = mem["location"] as? Dictionary<String, Any>{
                            let coord = CLLocation(
                                latitude: loc["latitude"] as! Double,
                                longitude: loc["longitude"] as! Double
                            )
                            
                            dist = coord.distance(from: self.groupLocation)
                            dist = dist.rounded()
                            
                        }
                        let u = User(name: fullname, Id: snap.key, username:username)
                        if (self.group.members.contains(u)){
                            self.memberCoords[self.group.members.count-1] = String(dist)
                            self.memberTableView.reloadData()
                        } else {
                            self.group.members.append(u)
                            self.memberTableView.insertRows(at: [IndexPath(row: self.group.members.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                            self.memberTableView.cellForRow(at: IndexPath(row: self.group.members.count-1, section: 0))?.detailTextLabel?.text = "\(dist) m"
                            self.memberCoords.append("\(dist) m")
                        }
                        
                    }
                    
                }
                
            })
            
        })
        
    }
//        
//    func getMemberInfo(memberIds: [String]){
//        var ref: DatabaseReference!
//        
//        ref = Database.database().reference()
//        print(memberIds)
//        for userID in memberIds {
//            let userRef = ref.child("users").child(userID);
//            self.group.members = [];
//            userRef.observe(.value, with: {(snap) -> Void in
//                if let userInfoDict = snap.value as? Dictionary<String, Any> {
//                    let fullname = userInfoDict["name"] as! String
//                    let username = userInfoDict["username"] as! String
//                    
//                    
//                    self.group.members.append(User(name: fullname, Id: snap.key, username:username))
//                    self.memberTableView.insertRows(at: [IndexPath(row: self.group.members.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
//                }
//                
//                
//            })
//        }
//        print(group.members)
//    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count: Int?
 
        if (tableView == self.memberTableView) {
            count = group.members.count;
        }
        
        return count!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        

        if tableView == self.memberTableView{
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "memberCell")
            }
            cell?.textLabel?.text = group.members[indexPath.row].name
            print(indexPath.row)
            print(self.memberCoords.count)
            if (self.memberCoords.count > indexPath.row) {
                cell?.detailTextLabel?.text = self.memberCoords[indexPath.row]
            }
            
        }
        
        return cell!;
    }
    
    
    
    
    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let dest = segue.destination as! SelectLocationViewController
//        
//        dest.group = self.group;
//        
//    }
    
    
}

//extension Date
//{
//    func toString( dateFormat format  : String ) -> String
//    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        return dateFormatter.string(from: self)
//    }
//    
//}
