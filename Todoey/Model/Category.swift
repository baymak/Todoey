//
//  Category.swift
//  Todoey
//
//  Created by buket aymak on 17.11.2018.
//  Copyright © 2018 buket aymak. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
 @objc dynamic var name: String = ""
    let items = List<Item>()
    
    
}
