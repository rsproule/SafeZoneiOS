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


class SelectLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    var group: Group = Group()
    
    let locationManager = CLLocationManager()
    var currentUserId: String = "";
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func myLoc(_ sender: UIButton) {
        let somePoint1 = LocationPoint(title: "User1Location", locationName: "User1", coordinate: myLocation.coordinate)
        //print(myLocation.coordinate)
        
       // map.addAnnotation(somePoint1)
        groupLoc = myLocation;
        locationManager.requestAlwaysAuthorization()
        
        updateLocationView(newLocation: myLocation)
    }
    
    
    @IBAction func setGroupLocation(_ sender: Any) {
        print("Set location: \(groupLoc)")
        
        // do the segue here
        
    }
    
    var myLocation = CLLocation()
    
    var groupLoc = CLLocation() //will need to get from user
//    var groupLocRadius: Double = 500.0 //will need to get from user
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
        groupLoc=locationValue
        let destLocation = LocationPoint(title: "GroupLocation", locationName: "Group", coordinate: groupLoc.coordinate)
        map.addAnnotation(destLocation)
        self.updateLocationView(newLocation: groupLoc)
        //self.monitorRegionAtLocation(center: groupLocation.coordinate, identifier: "SafeZone")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
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
    
//    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
//        if CLLocationManager.authorizationStatus() == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
//                let maxDistance = groupLocRadius
//                let region = CLCircularRegion(center: center, radius: maxDistance, identifier: identifier)
//                region.notifyOnExit = true
//                locationManager.startMonitoring(for: region)
//            }
//        }
//    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EventInfoViewController{
        
            dest.location = self.groupLoc
            dest.group = self.group
        }
        
        
        
     }
 
    
   
}


