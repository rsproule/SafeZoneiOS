//
//  EventInfoViewController.swift
//  GoogleToolboxForMac
//
//  Created by Ryan Sproule on 12/1/17.
//

import UIKit
import DateTimePicker
import MapKit
import FirebaseDatabase

class EventInfoViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBAction func selectStartTimeBtn(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.startTimeLbl.text = date.toString(dateFormat: "MMMM d, YYYY h:mm a")
        }
    }
    
    
    @IBOutlet weak var finishTimeLbl: UILabel!
    @IBAction func selectFinishTimeBtn(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.endDate = date;
            self.finishTimeLbl.text = date.toString(dateFormat: "MMMM d, YYYY h:mm a")
        }
    }
    

    @IBOutlet weak var radiusTextField: UITextField!
   
    
    
    @IBAction func startEventBtn(_ sender: Any) {
        let name = eventNameTextField.text!
        let startDate = Date().timeIntervalSince1970
        let endDate = self.endDate.timeIntervalSince1970;
        var members: [String: Any] = [:]
        let location: [String: Any] = [
            "latitude" : self.location.coordinate.latitude,
            "longitude" : self.location.coordinate.longitude
        ]
        let radius = Double(self.radiusTextField.text!)
            
        let groupID = self.group.id
        
        
        for user in self.group.members{
            members[user.Id] = [
                "name" : user.name,
                "username" : user.username,
                "location" : "TBD"
            ]
        }
        // current user is obv in the event
        members[CURRENT_USER.Id] = [
            "name" : CURRENT_USER.name,
            "username" : CURRENT_USER.username,
            "location" : location
        ]
        
        
        //Sanity checking
        if(radius == nil){
            return
        }
        if(name == ""){
            return
        }
        if finishTimeLbl.text == "Finish Time" {
            return
        }
        
        
        
        let event: [String: Any] = [
            "name" : name,
            "start" : startDate,
            "end" : endDate,
            "group" : groupID,
            "members" : members,
            "location" : location,
            "radius" : radius!
        ]
        
        
        // up to firebase
        var ref: DatabaseReference?
        
        ref = Database.database().reference();
        
        let eventsRef = ref?.child("events").childByAutoId()
        
        // put the whole event in the events sub
        eventsRef?.setValue(event);
        
        // give each member the event plus active Event
        for m in self.group.members {
            ref?.child("users").child(m.Id).child("events").child((eventsRef?.key)!).setValue(true);
            
            ref?.child("users").child(m.Id).child("activeEvent").setValue((eventsRef?.key)!);

        }
        
        // update the group's events
        ref?.child("groups").child(groupID).child("events").child((eventsRef?.key)!).setValue(true)
        
        // segue to active event page
        

        for controller in self.navigationController!.viewControllers as Array {
            if(tabBarController?.selectedIndex == 1){
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            
            if controller.isKind(of: GroupListViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        //should switch us to the current event tab
        tabBarController?.selectedIndex = 0

        
        
        
    }
    
    /// DATA that needs to be passed along
    var endDate: Date = Date()
    var group: Group = Group()
    var location: CLLocation = CLLocation()
    // Empty initial event
   // var newEvent: Event = Event(location: CLLocation(), name: "", date: Date(), Id: "", group: Group())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
