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
    var id : String;
    
    init(name: String, members: [User], events: [Event], id: String){
        self.events = events;
        self.groupName = name;
        self.members = members;
        self.id = id;
        
    }
    
    init(){
        self.events = [];
        self.groupName = "";
        self.members = [];
        self.id = ""
    }
    
    
    
}
