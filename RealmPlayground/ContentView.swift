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
            Button("サイズ") {
                try! Realm(configuration: self.config)
            }
            Button("update") {
                let realm = try! Realm(configuration: self.config)
                try! realm.write {
                    for i in 0...100000 {
                        let dog = Dog()
                        dog.name = "hoge" + i.description
                        dog.age = i
                        dog.updated = Date()
                        realm.add(dog, update: .modified)
                    }
                }
            }
            Button("insert") {
                let realm = try! Realm(configuration: self.config)
                try! realm.write {
                    for i in 0...100000 {
                        let dog = Dog()
                        dog.name = "hoge" + i.description
                        dog.age = i
                        dog.updated = Date()
                        realm.add(dog, update: .modified)
                    }
                }
            }
            Button("レコード数") {
                let realm = try! Realm(configuration: self.config)
                let dogs = realm.objects(Dog.self)
                print(dogs.count.description)
            }
            
            Button("invalidate")  {
                let realm = try! Realm(configuration: self.config)
                realm.invalidate()
            }
            Button("コピーで置き換え")  {
                let realm = try! Realm(configuration: self.config)
                realm.writeCopy(toFile: <#T##URL#>)
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
