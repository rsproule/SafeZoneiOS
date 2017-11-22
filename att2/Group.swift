//
//  Group.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation


class Group {
    
    var groupName: String;
    var members: [User];
    var events: [Event];
    
    
    init(name: String, members: [User], events: [Event]){
        self.events = events;
        self.groupName = name;
        self.members = members;
    }
    
    
    
}
