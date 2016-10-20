//
//  Item.swift
//  ToDoFirebase
//
//  Created by Thiago Cortat on 16/10/16.
//  Copyright © 2016 Infnet. All rights reserved.
//

import Foundation

class Item {
    
    var title: String?
    var description: String?
    var key: String
    
    init(key:String) {
        self.key = key
    }
}
