//
//  ElapsedButtonView.swift
//  RealmPlayground
//
//  Created by H5266 on 2019/11/26.
//  Copyright © 2019 福田走. All rights reserved.
//

import SwiftUI

struct ElapsedButton: View {
    private func elapsed() {
        let start = Date()
        action()
        let elapsed = Date().timeIntervalSince(start)
        print("\(text): " + String(format: "%.3f", elapsed))
    }

    private let text: String
    private let action: () -> Void

    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }


    var body: some View {
        Button(action: self.elapsed , label: { Text(self.text) })
            .padding(5)
            .font(.title)
    }
}

struct ElapsedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ElapsedButton("aaaaaa") { }
            ElapsedButton("aaaaaa") { }
            ElapsedButton("aaaaaa") { }
            ElapsedButton("aaaaaa") { }
            ElapsedButton("aaaaaa") { }

        }
    }
}
