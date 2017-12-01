//
//  Event.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation
import MapKit

class Event: Equatable {
    
    
    var location: CLLocation
    var eventName: String;
    var date: Date;
    var group: Group;
    var Id: String
    
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        if(lhs.eventName != rhs.eventName){
            return false;
        }
        if(lhs.date != rhs.date){
            return false;
        }
        if(lhs.location != rhs.location){
            return false;
        }
        
        return true;
    }
    
    init(location: CLLocation, name: String, date: Date, Id: String, group: Group){
        self.date = date;
        self.location = location;
        self.eventName = name;
        self.Id = Id;
        self.group = group;
    }
    
    
}
