//
//  ContentView.swift
//  RealmPlayground
//
//  Created by 福田走 on 2019/11/25.
//  Copyright © 2019 福田走. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var value = "a"
    private let config = Realm.Configuration(
        schemaVersion: 3,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
            }
        },
        shouldCompactOnLaunch: { total, used in
            print(" \(used)/\(total)")
            return false
        }
    )

    init() {
    }

    var body: some View {
        VStack {
            TextField("", text: $value)
            Button("更新") {
                try! Realm(configuration: self.config)
            }
            Button("書き込み") {
                let realm = try! Realm(configuration: self.config)
                try! realm.write {
                    for i in 0...100000 {
                        let dog = Dog()
                        dog.name = "hoge"
                        dog.age = i
                        dog.updated = Date()
                        realm.add(dog)
                    }
                }
            }
            Button("レコード数") {
                let realm = try! Realm(configuration: self.config)
                let dogs = realm.objects(Dog.self)
                print(dogs.count.description)


            }
            Button("リセット") {
                let realm = try! Realm(configuration: self.config)
                try! realm.write {
                    realm.deleteAll()
                }

            }
        }
    }




}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()
    override internal static func primaryKey() -> String? { "name" }
}

extension URL {
    internal var fileSize: UInt64? {
        return attributes?.fileSize()
    }

    internal var attributes: NSDictionary? {
        return (try? FileManager.default.attributesOfItem(atPath: self.path)) as NSDictionary?
    }
}
