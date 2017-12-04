//
//  HistoricEventDetail.swift
//  att2
//
//  Created by Azeez Abdikarim on 12/3/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//


import UIKit
import MapKit

class HistoricEventDetail: UIViewController, MKMapViewDelegate {
    
    var event:Event!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var members: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupName.text = event.eventName
        
        let theDate : Date = event.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss"
        let todaysDate = dateFormatter.string(from: theDate)
        date.text = todaysDate
        
        let theSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: event.location.coordinate, span: theSpan)
        map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = event.location.coordinate
        map.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchToCurrentEvent(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
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

