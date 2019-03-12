//
//  Category.swift
//  Study Case
//
//  Created by Rudi Wijaya on 11/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import Foundation


class Category {
    
    var id: Int;
    var name: String;
    var parent: Category?
    
    init(id: Int, name: String) {
        self.id = id;
        self.name = name;
    }
    
    init(id: Int, name: String, parent: Category) {
        self.id = id;
        self.name = name;
        self.parent = parent;
    }
    
    
}
