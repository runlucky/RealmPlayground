//
//  RealmExtensions.swift
//  RealmPlayground
//
//  Created by H5266 on 2019/11/26.
//  Copyright © 2019 福田走. All rights reserved.
//

import RealmSwift

extension Realm {
    func compactCopy(destination: URL) {
        destination.delete()
        try! writeCopy(toFile: destination)
    }
}
