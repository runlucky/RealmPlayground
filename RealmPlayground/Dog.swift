//
//  Dog.swift
//  RealmPlayground
//
//  Created by H5266 on 2019/11/26.
//  Copyright © 2019 福田走. All rights reserved.
//

import RealmSwift

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()
    override internal static func primaryKey() -> String? { "name" }
    override var description: String {
        "name: \(name), age: \(age), created: \(created), updated: \(updated)"
    }
}
