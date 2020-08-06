//
//  Category.swift
//  Todoey
//
//  Created by Yash  on 30/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    var items = List<Item>()
}
