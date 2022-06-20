//
//  CreateTimerView.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

struct CreateTimerView: View {
    @State private var name = ""
    @ObservedObject var keyboard = TimeInputKeyboardModel()
    var saveFunc: (_ name: String, _ duration: TimeInterval) -> ()

    var body: some View {
        VStack {
            TextField(
                "Timer name",
                text: $name
            )
                .border(.primary)
                .textFieldStyle(.roundedBorder)
            
            Text("\(keyboard.value.formattedTimeNoMilli)")
            HStack {
                TimeInputKeyboardView(model: keyboard)
                Button(action: {saveFunc(name, keyboard.value)}) {
                    Text("Create").font(.system(size:20))
                        .frame(maxHeight: 160)
                }
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(12)
            }
        }
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
