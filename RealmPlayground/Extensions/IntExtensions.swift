//
//  IntExtensions.swift
//  RealmPlayground
//
//  Created by H5266 on 2019/11/26.
//  Copyright © 2019 福田走. All rights reserved.
//

import Foundation

extension Int {
    var comma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: self as NSNumber) ?? self.description
    }
}
