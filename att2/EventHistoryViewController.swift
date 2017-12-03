//
//  EventHistoryViewController.swift
//  att2
//
//  Created by Ryan Sproule on 12/2/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class EventHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   


    @IBOutlet weak var eventsTableView: UITableView!
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEvents(){
        self.events = [];
        var ref: DatabaseReference?
        
        ref = Database.database().reference()
            .child("users")
            .child(CURRENT_USER.Id)
            .child("events")
        
        ref?.observe(.childAdded, with:{(snap) -> Void in
            let eventId = snap.key as! String;
            ref = Database.database().reference()
                .child("events")
                .child(eventId)
            
            ref?.observe(.value, with: {(s) -> Void in
                if let event = s.value as? Dictionary<String, Any> {
                    let name = event["name"] as! String;
                    let member = event["members"] as! Dictionary<String, Any>
                    let radius = event["radius"] as! Double
                    let location = event["location"] as! Dictionary<String, Any>
                    let startTime = event["start"] as! TimeInterval
                    let endTime = event["end"] as! TimeInterval
                    let groupID = event["group"] as! String;
                    
                    let evnt = Event(
                        location: CLLocation(
                            latitude: location["latitude"] as! CLLocationDegrees,
                            longitude: location["longitude"] as! CLLocationDegrees
                        ),
                        name: name,
                        date: Date(timeIntervalSince1970: startTime),
                        Id: eventId,
                        group: Group()
                    )
                    
                    
                    self.events.append(evnt);
                    print(self.events)
                    //self.eventsTableView.insertRows(at: [IndexPath(row: self.events.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                    //self.eventsTableView.reloadData()
                }else{
                    print("error")
                }
                
            })
            
        })
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("building..")
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "eventCell")
        }
        // set the text from the data model
        cell?.textLabel?.text = self.events[indexPath.row].eventName
        cell?.detailTextLabel?.text = self.events[indexPath.row].date.toString(dateFormat: "MMMM d, YYYY h:mm a")
        
        return cell!;
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
