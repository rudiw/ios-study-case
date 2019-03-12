//
//  Breadcrumb.swift
//  Study Case
//
//  Created by Rudi Wijaya on 12/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation


class Breadcrumb {
    var id: String
    var name: String
    var child: Breadcrumb?
    
    init(id: String, name: String, child: Breadcrumb?) {
        self.id = id;
        self.name = name;
        self.child = child;
    }
}
