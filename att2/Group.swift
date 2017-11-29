//
//  Group.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation


class Group: Hashable{
    var hashValue: Int
    
    static func ==(lhs: Group, rhs: Group) -> Bool {
        if(lhs.groupName != rhs.groupName){
            return false;
        }
        
        for e in lhs.events {
            for re in rhs.events{
                if(e != re){
                    return false;
                }
            }
        }
        
        for m in lhs.members {
            for rm in rhs.members {
                if(m != rm){
                    return false;
                }
            }
        }
        
        return true
    }
    
    
    var groupName: String;
    var members: [User];
    var events: [Event];
    
    
    init(name: String, members: [User], events: [Event]){
        self.events = events;
        self.groupName = name;
        self.members = members;
        
        self.hashValue = groupName.hashValue
    }
    
    
    
}
