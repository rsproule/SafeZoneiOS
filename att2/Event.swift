//
//  Event.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation


class Event {
    var location: LocationPoint
    var eventName: String;
    var date: Date;
    
    
    init(location: LocationPoint, name: String, date: Date){
        self.date = date;
        self.location = location;
        self.eventName = name;
    }
    
    
}
