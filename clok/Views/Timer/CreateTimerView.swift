//
//  CreateTimerView.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

struct CreateTimerView: View {
    enum Field: Hashable {
        case name
        case timeInput
    }
    
    @State private var name = ""
    @StateObject var keyboard = TimeInputKeyboardModel()
    @State private var showTimeInput = true
    var saveFunc: (_ name: String, _ duration: TimeInterval) -> ()
    let sizes = buttonSizes()

    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            
            TextField(
                "Timer name",
                text: $name
            )
            .font(Font.system(size: sizes.fontSize))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .textFieldStyle(.roundedBorder)
            .onTapGesture {showTimeInput = false}
            .onSubmit {showTimeInput = true}
            
            Spacer()
            
            Text(keyboard.value.formattedTimeNoMilliLeadingZero)
            .font(Font.monospaced(.system(size: sizes.bigTimeFont))())
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            
            Group {
                Text((Date() + keyboard.value).displayTime)
                Text(Date().isSameDayAs(comp: Date() + keyboard.value) ? "" : " " + (Date() + keyboard.value).displayDayDate)
            }
            .font(Font.system(size: sizes.fontSize))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            
            Spacer()
            
            if (showTimeInput) {
                VStack {
                    TimeInputKeyboardView(model: keyboard)
                    Button(action: {saveFunc(name, keyboard.value)}) {
                        Image(systemName: "play.circle")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: sizes.inputHeight)
                    }
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(sizes.radius)
                }
                .frame(maxHeight: 300)
            } else {
                Spacer()
            }
        }
        .gesture(
            // Capturing "tap outside the textinput to dismiss" intent and dismissing
            TapGesture().onEnded { _ in
                showTimeInput = true
                hideKeyboard()
            }
        )
    }
}


struct CreateTimerView_Previews: PreviewProvider {
  static var previews: some View {
        Group {
            CreateTimerView(saveFunc: {name,duration in return})
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
            }
        }
}
