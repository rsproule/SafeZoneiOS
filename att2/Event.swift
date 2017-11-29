//
//  Event.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation


class Event: Equatable {
    
    
    var location: LocationPoint
    var eventName: String;
    var date: Date;
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
    
    init(location: LocationPoint, name: String, date: Date, Id: String){
        self.date = date;
        self.location = location;
        self.eventName = name;
        self.Id = Id;
    }
    
    
}
