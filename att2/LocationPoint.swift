//
//  File.swift
//  SafeZone
//
//  Created by McCormack on 11/12/17.
//  Copyright © 2017 McCormack. All rights reserved.
//

import Foundation
import MapKit

class LocationPoint: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
