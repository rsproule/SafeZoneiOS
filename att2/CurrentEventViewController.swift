//
//  CurrentEventViewController.swift
//  att2
//
//  Created by Ryan Sproule on 12/2/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class CurrentEventViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
   
    @IBAction func showEventInfo(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func gotoMyLocation(_ sender: Any) {
        let geoLocation = CLGeocoder()
        geoLocation.reverseGeocodeLocation(myLocation, completionHandler: { (data, error) -> Void in
            self.map.centerCoordinate = self.myLocation.coordinate
        })
    }
    @IBAction func gotoGroupLocation(_ sender: Any) {
        let geoLocation = CLGeocoder()
        geoLocation.reverseGeocodeLocation(groupLocation, completionHandler: { (data, error) -> Void in
            self.map.centerCoordinate = self.groupLocation.coordinate
            
            let reg = MKCoordinateRegionMakeWithDistance(self.groupLocation.coordinate, self.radius*2, self.radius*2)
            self.map.setRegion(reg, animated: true)
            self.updateLocationView(newLocation: self.groupLocation, radius: self.radius)
            
        })
        

    }
    
    
    var locationManager = CLLocationManager();
    var groupLocation =  CLLocation();
    var myLocation = CLLocation();
    var hasActiveEvent = true;
    var radius = 0.0
    var memberAnnotations: [MKAnnotation] = []
    var eventId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        initializeEvent();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeEvent(){
        var ref: DatabaseReference?
        ref = Database.database().reference()
            .child("users")
            .child(CURRENT_USER.Id)
            .child("activeEvent");
        
        ref?.observe(.value, with: {(snap) -> Void in

            if (snap.value is NSNull){
                let alertController = UIAlertController(title: "No event", message:
                    "Please create an event.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else{
                self.eventId = snap.value as! String
                self.listenToEvent(eventId: self.eventId);
            }
            
        })
        
    }
    
    func listenToEvent(eventId: String){
        var ref: DatabaseReference?
        ref = Database.database().reference()
            .child("events")
            .child(eventId);
        ref?.observe(DataEventType.value, with: {(snap) -> Void in
           
            
            
            
            //clear the annotations
            self.memberAnnotations = [];
            self.map.removeAnnotations(self.map.annotations)
            
            if let event = snap.value as? Dictionary<String, Any> {
                /* --------------------- general event stuff --------------------------------- */
                let loc = event["location"] as! Dictionary<String, Any>
                self.groupLocation = CLLocation(
                    latitude: loc["latitude"] as! Double,
                    longitude: loc["longitude"] as! Double
                )
                
                self.radius = (event["radius"] as! Double); // should find actual conversion to miles
                
                self.updateLocationView(newLocation: self.groupLocation, radius: self.radius);
                
                /* --------------------- Member stuff --------------------------------- */
                let members = event["members"] as! Dictionary<String, Any>
                
                for (_, v) in members{
                    let mem = v as! Dictionary<String, Any>
                    let nm = mem["name"] as! String
                    let usrnm = mem["username"] as! String
                    if let memloc = mem["location"] as? Dictionary<String, Any>{
                        
                        let memberCoord = CLLocationCoordinate2D(
                            latitude: memloc["latitude"] as! Double,
                            longitude: memloc["longitude"] as! Double
                        )
                        
                        let destLocation = LocationPoint(
                            title: nm,
                            locationName: usrnm,
                            coordinate: memberCoord
                        )
                        
                        self.memberAnnotations.append(destLocation);
                        let currCoord = CLLocation(
                            latitude: memloc["latitude"] as! Double,
                            longitude: memloc["longitude"] as! Double
                        )
                        let dist = currCoord.distance(from: self.groupLocation)
                        if (dist>self.radius){
                            let alertController = UIAlertController(title: "Member out of range", message:
                                "\(nm) out of range. Send help.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else{
                        //User has not provided a location yet
                        print("User has not given a location")
                    }
                    
                }
                
                self.map.addAnnotations(self.memberAnnotations)
                
                /* --------------------- endof Member stuff --------------------------------- */
                
            }else{
                print("FAILED to read")
            }
        })
      
    }
    
    func sendLocation(){
       // print(myLocation)
        
        if(self.eventId == ""){
            return;
        }
        var ref: DatabaseReference?
        
        ref = Database.database().reference()
            .child("events")
            .child(self.eventId)
            .child("members")
            .child(CURRENT_USER.Id)
            .child("location")
        
        ref?.setValue([
            "latitude" : myLocation.coordinate.latitude,
            "longitude" : myLocation.coordinate.longitude
        ])
    }
    
    var firstLoaded = false;
    func updateLocationView(newLocation: CLLocation, radius: Double) {
        
        let geoLocation = CLGeocoder()
        
        geoLocation.reverseGeocodeLocation(newLocation, completionHandler: { (data, error) -> Void in
            if(!self.firstLoaded){
                self.map.centerCoordinate = newLocation.coordinate
                let reg = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, radius, radius)
                self.map.setRegion(reg, animated: true)
                self.addRadiusCircle(location: newLocation, radius: radius)
                self.firstLoaded = true;
            }
            self.map.showsUserLocation = true
            
        })
    }
    
    func addRadiusCircle(location: CLLocation, radius: Double){
            self.map.delegate = self
            let circle = MKCircle(center: location.coordinate, radius: radius)
            self.map.add(circle)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 0, green: 0, blue: 250, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        
        sendLocation()
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
