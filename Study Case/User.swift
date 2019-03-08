//
//  User.swift
//  Study Case
//
//  Created by Rudi Wijaya on 08/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation


enum UserType {
    case FACEBOOK
    case TWITTER
    case GOOGLE
}

class User {
    var id: String
    var email: String
    var fullName: String
    var firstName: String
    var lastName: String
    var token: String
    var type: UserType
    
    init(id: String, email: String, fullName: String, firstName: String, lastName: String, token: String, type: UserType) {
        self.id = id;
        self.email = email;
        self.fullName = fullName;
        self.firstName = firstName;
        self.lastName = lastName;
        self.token = token;
        self.type = type;
    }
    
    
}
