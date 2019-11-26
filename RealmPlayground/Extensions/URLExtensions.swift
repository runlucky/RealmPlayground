//
//  URLExtensions.swift
//  RealmPlayground
//
//  Created by H5266 on 2019/11/26.
//  Copyright © 2019 福田走. All rights reserved.
//

import Foundation

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
