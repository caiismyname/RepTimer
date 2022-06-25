//
//  TimeInputKeyboard.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

struct TimeInputKeyboardView: View {
    @State var model: TimeInputKeyboardModel
    let keyboard = "123|456|789| 0<"
    
    var body: some View {
        let lines = keyboard.split(separator: "|")
        VStack {
            ForEach(lines, id: \.self) { line in
                HStack {
                    let keyArray = line.map { String($0) }
                    ForEach(keyArray, id: \.self) { digit in
                        TimeInputKeyView(model: model, digit: digit)
                    }
                }
            }
        }
    }
}

struct TimeInputKeyboardViewPreviews: PreviewProvider {
    static var previews: some View {
        let model = TimeInputKeyboardModel()
        Group {
            TimeInputKeyboardView(model: model)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
