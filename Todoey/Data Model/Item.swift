//
//  Item.swift
//  Todoey
//
//  Created by Yarden Katz on 22/04/2021.

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects<Category>(fromType: Category.self, property: "items")
}

