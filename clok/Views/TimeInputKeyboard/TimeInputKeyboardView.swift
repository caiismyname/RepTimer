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
        .frame(height: 225.0)
    }
}

struct TimeInputKeyView: View {
    @ObservedObject var model: TimeInputKeyboardModel
    var digit: String
    
    var body: some View {
        Button {
            model.addDigit(digit: digit)
        } label: {
            switch digit {
            case "<":
                Image(systemName: "delete.backward")
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: .infinity)
            default:
                Text(digit)
                    .font(Font.monospaced(.system(size: Sizes.fontSize))())
                    .minimumScaleFactor(0.1)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .padding(6)
        .foregroundColor(Color(UIColor.label))
    }
}


struct TimeInputDisplay: View {
    @ObservedObject var keyboard: TimeInputKeyboardModel
    
    var body: some View {
        HStack {
            if keyboard.input.literalInputString.split(separator: ":").count == 3 {
                VStack(alignment: .center) {
                    Text(keyboard.input.literalInputString.split(separator: ":").reversed()[2])
                    Text("hours")
                        .font(.system(size: Sizes.calculatorFontSize, design: .monospaced))
                }
                Text(":")
                    .padding([.bottom], Sizes.calculatorFontSize)
            }
            
            VStack(alignment: .center) {
                Text(keyboard.input.literalInputString.split(separator: ":").reversed()[1])
                Text("minutes")
                    .font(.system(size: Sizes.calculatorFontSize, design: .monospaced))
            }
            
            Text(":")
                .padding([.bottom], Sizes.calculatorFontSize)
            
            VStack(alignment: .center) {
                Text(keyboard.input.literalInputString.split(separator: ":").reversed()[0])
                Text("seconds")
                    .font(.system(size: Sizes.calculatorFontSize, design: .monospaced))
            }
        }
            .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
            .minimumScaleFactor(0.01)
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


