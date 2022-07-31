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
    var saveFunc: (_ name: String, _ duration: TimeInterval) -> ()
    @State private var showTimeInput = true

    var body: some View {
        VStack (alignment: .center) {
            TextField(
                "Timer name",
                text: $name
            )
            .font(Font.system(size: 25))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .textFieldStyle(.roundedBorder)
            .onTapGesture {showTimeInput = false}
            .onSubmit {showTimeInput = true}
            .padding(.top, 50)
            
            Spacer()
            
            Text(keyboard.value.formattedTimeNoMilliLeadingZero)
            .font(Font.monospaced(.system(size: 80))())
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            
            Group {
                Text((Date() + keyboard.value).displayTime)
                Text(Date().isSameDayAs(comp: Date() + keyboard.value) ? "" : " " + (Date() + keyboard.value).displayDayDate)
            }
            .font(Font.system(size: 20))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            
            Spacer()
            
            if (showTimeInput) {
                HStack {
                    TimeInputKeyboardView(model: keyboard)
                    Button(action: {saveFunc(name, keyboard.value)}) {
                        Image(systemName: "play.fill")
                            .padding()
                    }
                        .frame(maxHeight: .infinity)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(12)
                }
                .frame(height: 300)
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
