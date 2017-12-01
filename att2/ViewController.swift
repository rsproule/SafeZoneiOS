//
//  ViewController.swift
//  SafeZone
//
//  Created by McCormack on 11/12/17.
//  Copyright © 2017 McCormack. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

// Sasha made this change !!!!!!

// GLOBAL USER DEFINED HERE CAN BE ACCESSED IN ANY VC
var CURRENT_USER_ID: String = "";


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentUserId: String = "";
    
    @IBOutlet weak var map: MKMapView!

    @IBAction func myLoc(_ sender: UIButton) {
        let somePoint1 = LocationPoint(title: "User1Location", locationName: "User1", coordinate: myLocation.coordinate)
        //print(myLocation.coordinate)
        
        map.addAnnotation(somePoint1)
        
        locationManager.requestAlwaysAuthorization()
        
        updateLocationView(newLocation: myLocation)
    }

    
    
    var myLocation = CLLocation()
    
    var groupLocation = CLLocation() //will need to get from user
    var groupLocRadius: Double = 500.0 //will need to get from user
    var wantsUpdate: Bool = false
  
    

 
    @IBAction func unwindToMap(_ sender: UIStoryboardSegue){
        if sender.source is SearchViewController {
            if let senderVC = sender.source as? SearchViewController {
                let locValue = CLLocation(latitude: senderVC.coords.latitude, longitude: senderVC.coords.longitude)
                self.setDestination(locationValue: locValue)
            }
            
        }
    }
    
    func setDestination(locationValue: CLLocation){
        groupLocation=locationValue
        let destLocation = LocationPoint(title: "GroupLocation", locationName: "Group", coordinate: groupLocation.coordinate)
        map.addAnnotation(destLocation)
        self.updateLocationView(newLocation: groupLocation)
        self.monitorRegionAtLocation(center: groupLocation.coordinate, identifier: "SafeZone")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //completeSearchResults.delegate=(self as! MKLocalSearchCompleterDelegate)
    }
    
    func updateLocationView(newLocation: CLLocation) {
        
        let geoLocation = CLGeocoder()
        
        geoLocation.reverseGeocodeLocation(newLocation, completionHandler: { (data, error) -> Void in
            let mark = data!
            let loc: CLPlacemark = mark[0]
            self.map.centerCoordinate = newLocation.coordinate
            let areaAddress = loc.locality
            let reg = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500)
            self.map.setRegion(reg, animated: true)
            self.map.showsUserLocation = true
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        
        let accuracy = myLocation.horizontalAccuracy
       // print("accuracy is \(accuracy)")
        
        
        //references Shrikar Archak
        //updateLocationView(myLocation: myLocation)
        

        
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                let maxDistance = groupLocRadius
                let region = CLCircularRegion(center: center, radius: maxDistance, identifier: identifier)
                region.notifyOnExit = true
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //alert if out of region
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            triggerLeftArea(regionID: identifier)
            
        }
    }
    
    func triggerLeftArea(regionID: String) {
        //alert everyone
        //called when user's location has crossed boundary and remained out for 20 seconds
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        @desc determines whether users are outside the group range
        @param1 dictionary of Users and their Location
        @param2 the range determined by the group settings
        @return tuple of the avg location point and a dictionary of the user and boolean for their status (false = outside range)
    */
    public func checkUserStatuses(user_locations : [String : CLLocationCoordinate2D], meters_range:Double)->(avg_location:CLLocation, user_statuses:[String : Bool]){
        var total_lat = 0.0;
        var total_long = 0.0;
        for user in user_locations {
            total_lat += Double(""+user.value.latitude.description)!
            total_long += Double(""+user.value.longitude.description)!
        }
        let avg_lat = (total_lat)/Double(user_locations.count)
        let avg_long = (total_long)/Double(user_locations.count)
        let avg = CLLocation(latitude: CLLocationDegrees(avg_lat), longitude: CLLocationDegrees(avg_long))
        var response: [String : Bool] = [:]
        for user in user_locations{
            if(avg.distance(from: CLLocation(latitude: user.value.latitude, longitude: user.value.longitude)) > meters_range){
                response[user.key] = false
            } else {
                response[user.key] = true
            }
        }
        
        return (avg, response)
    }
    
    
}

