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


class GroupInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var groupEventTable: UITableView!
    
    
    @IBAction func createEventButton(_ sender: UIButton) {
    
    }
    
    var group: Group = Group();
    
    var eventIds: [String] = []
    var memberIds: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameLabel.text = group.groupName;
        
        memberTableView.delegate = self
        memberTableView.dataSource = self;
        //memberTableView.register(UITableViewCell.self, forCellReuseIdentifier: "memberCell")
        
        groupEventTable.delegate = self;
        groupEventTable.dataSource = self
        //groupEventTable.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        
        getEventInfo(eventIds: self.eventIds)
        getMemberInfo(memberIds: self.memberIds)
    }
    
    
    func getMemberInfo(memberIds: [String]){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        for userID in memberIds {
            let userRef = ref.child("users").child(userID);
            self.group.members = [];
            userRef.observe(.value, with: {(snap) -> Void in
                if let userInfoDict = snap.value as? Dictionary<String, Any> {
                    let fullname = userInfoDict["name"] as! String
                    let username = userInfoDict["username"] as! String
                    
                
                    self.group.members.append(User(name: fullname, Id: snap.key, username:username))
                    self.memberTableView.insertRows(at: [IndexPath(row: self.group.members.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                }

                
            })
        }
    }
    
    func getEventInfo(eventIds: [String]){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        for eventId in eventIds {
            let eventsRef = ref.child("events").child(eventId);
            
            self.group.events = [];
            eventsRef.observe( .value, with: {(snap) -> Void in
                if let eventInfoDict = snap.value as? Dictionary<String, Any> {
                    let eventName = eventInfoDict["name"] as! String
                    let loc: CLLocation = self.parseLocation(locationDict: eventInfoDict["location"]!)

                    let date: Date = Date(timeIntervalSince1970: eventInfoDict["start"] as! Double)
                    
                    self.group.events.append(Event(location: loc, name: eventName, date: date, Id: eventId, group: self.group))
                    self.groupEventTable.insertRows(at: [IndexPath(row: self.group.events.count-1, section: 0)], with: UITableViewRowAnimation.automatic)

                }else{
                    print("Casting ERROR--> Probably BAD DATA")
                }

            })
        }
        
        
    }
    
    func parseLocation(locationDict: Any) -> CLLocation{
        
        let loc = locationDict as! Dictionary<String, Any>
        
        let latitude = loc["latitude"] as! Double
        let longitude = loc["longitude"] as! Double
      //  let name = loc["name"] as! String
        //let coord = CLLocationCoordinate2DMake(latitude, longitude)
        return CLLocation(latitude: latitude, longitude: longitude)
        //return LocationPoint(title: "Event Location", locationName: name, coordinate: coord)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        var count: Int?
        
        if(tableView == self.groupEventTable) {
            count = group.events.count;
        }
        if (tableView == self.memberTableView) {
            count = group.members.count;
        }
        
        return count!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if tableView == self.groupEventTable{
            //cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
            cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "eventCell")
            }
            cell?.textLabel?.text = group.events[indexPath.row].eventName
            cell?.detailTextLabel?.text = group.events[indexPath.row].date.toString(dateFormat: "dd-MM-YYYY");
            
        }
        if tableView == self.memberTableView{
            cell = tableView.dequeueReusableCell(withIdentifier: "memberCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "memberCell")
            }
            cell?.textLabel?.text = group.members[indexPath.row].name
            //cell?.detailTextLabel?.text = group.members[indexPath.row].Id
            
        }
        
        return cell!;
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! SelectLocationViewController
        
        dest.group = self.group;
        
    }
 

}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
