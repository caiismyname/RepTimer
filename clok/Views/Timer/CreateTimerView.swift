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
    @State var repeatAlert = true
    var saveFunc: (_ name: String, _ duration: TimeInterval, _ repeatAlert: Bool) -> ()

    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Group {
                // Name input
                TextField(
                    "Timer name",
                    text: $name
                )
                .font(Font.system(size: Sizes.fontSize))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .onTapGesture {showTimeInput = false}
                .onSubmit {showTimeInput = true}
                
                // Repeat Alert toggle
                Toggle(isOn: $repeatAlert) {
                    Text("Repeat sound until stopped")
                        .font(.system(size: Sizes.smallFontSize))
                }
            }
                .padding()
            
            // Keyboards (time input, timer name, it swaps between them)
            if (showTimeInput) {
//                // Projected end time
//                Group {
//                    Text((Date() + keyboard.value).displayTime)
//                    Text(Date().isSameDayAs(comp: Date() + keyboard.value) ? "" : " " + (Date() + keyboard.value).displayDayDate)
//                }
//                    .font(Font.system(size: Sizes.fontSize))
//                    .minimumScaleFactor(0.1)
//                    .lineLimit(1)
//
                // Timer duration
                TimeInputDisplay(keyboard: keyboard)
                
                Spacer()
                
                TimeInputKeyboardView(model: keyboard)
                Button(action: {saveFunc(name, keyboard.value, repeatAlert)}) {
                    Image(systemName: "play.circle")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: Sizes.inputHeight)
                }
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(Sizes.radius)
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
            CreateTimerView(saveFunc: {name,duration,repeatAlert in return})
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
                .preferredColorScheme(.dark)
            }
        }
}
