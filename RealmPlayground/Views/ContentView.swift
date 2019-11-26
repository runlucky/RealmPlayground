//
//  ContentView.swift
//  RealmPlayground
//
//  Created by 福田走 on 2019/11/25.
//  Copyright © 2019 福田走. All rights reserved.
//

import SwiftUI
import RealmSwift

fileprivate var compacted = true

struct ContentView: View {

    private var config: Realm.Configuration {
        Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            },
            shouldCompactOnLaunch: { total, used in
                print("size: \(used.comma)/\(total.comma)(\(self.size))")
                if compacted { return false }
                compacted = true
                return true
            }
        )
    }

    private var realm: Realm {
        try! Realm(configuration: config)
    }

    private var path: URL {
        Realm.Configuration.defaultConfiguration.fileURL!
    }

    private var temp: URL {
        path.deletingLastPathComponent().appendingPathComponent("temp.realm")
    }

    private var size: String {
        path.byte
    }

    var body: some View {
        VStack {
            VStack {
                ElapsedButton("サイズ"){
                    _ = self.realm
                }
                ElapsedButton("update") {
                    let realm = self.realm
                    let dogs = self.realm.objects(Dog.self)
                    try! realm.write {
                        dogs.forEach { dog in
                            dog.age += 1
                            dog.updated = Date()
                            realm.add(dog, update: .modified)
                        }
                    }
                }
                ElapsedButton("insert") {
                    let realm = self.realm
                    try! realm.write {
                        for i in 0...100000 {
                            let dog = Dog()
                            dog.name = NSUUID().uuidString + i.description
                            dog.age = i
                            dog.updated = Date()
                            realm.add(dog, update: .modified)
                        }
                    }
                }
                ElapsedButton("レコード数") {
                    let dogs = self.realm.objects(Dog.self)
                    print("レコード数: " + dogs.count.description)
                }
                ElapsedButton("invalidate") {
                    self.realm.invalidate()
                }
                ElapsedButton("コピー") {
                    self.realm.compactCopy(destination: self.temp)
                    print("コピー: \(self.size) → \(self.temp.byte)")
                }
                ElapsedButton("置き換え") {
                    self.temp.replace(to: self.path)
                }
            }
            VStack {
                ElapsedButton("出力") {
                    let dogs = self.realm.objects(Dog.self).sorted(byKeyPath: "name")
                    print("first: " + (dogs.first?.description ?? "nil"))
                    print("last : " + (dogs.last?.description ?? "nil"))
                }

                ElapsedButton("レコード削除") {
                    let realm = self.realm
                    let dogs = realm.objects(Dog.self)
                    try! realm.write {
                        realm.delete(dogs)
                    }
                }

                ElapsedButton("出力(1000)") {
                    guard let dog = self.realm.objects(Dog.self).filter("age == %@", 1000).first else {
                        print("not found")
                        return
                    }
                    print("1000: " + dog.description)
                }

                ElapsedButton("レコード削除(1000)") {
                    let realm = self.realm
                    let dogs = realm.objects(Dog.self).filter("age == %@", 1000)
                    try! realm.write {
                        realm.delete(dogs)
                    }
                }

                ElapsedButton("物理削除") {
                    self.path.delete()
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
    override var description: String {
        "name: \(name), age: \(age), created: \(created), updated: \(updated)"
    }
}

extension URL {
    internal var fileSize: UInt64? {
        return attributes?.fileSize()
    }

    internal var byte: String {
        guard let size = fileSize else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: size as NSNumber) ?? self.description
    }

    internal var attributes: NSDictionary? {
        return (try? FileManager.default.attributesOfItem(atPath: self.path)) as NSDictionary?
    }

    func delete() {
        if FileManager.default.fileExists(atPath: self.path) {
            try! FileManager.default.removeItem(at: self)
        }
    }

    func replace(to: URL) {
        to.delete()
        try! FileManager.default.moveItem(at: self, to: to)
    }
}

extension Int {
    var comma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? self.description
    }
}

extension Realm {
    func compactCopy(destination: URL) {
        destination.delete()
        try! writeCopy(toFile: destination)
    }
}
