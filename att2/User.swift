//
//  User.swift
//  att2
//
//  Created by Ryan Sproule on 11/21/17.
//  Copyright © 2017 Sasha CSE438. All rights reserved.
//

import Foundation


class User: Equatable {
    var name: String;
    var username: String;
    var Id: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        if(lhs.name != rhs.name){
            return false;
        }
        
        return true;
    }
    
    init(name: String, Id: String, username: String) {
        self.name = name;
        self.Id = Id
        self.username = username
    }
    
    // more TODO
    
}
