//
//  TimeInputKeyView.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

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
                  .aspectRatio(1.0, contentMode: .fit)
                  .frame(maxWidth: .infinity)
            }
            
        }
            .padding(6)
            .background {
              RoundedRectangle(cornerRadius: 5.0)
                .stroke()
            }
            .foregroundColor(Color(UIColor.label))
    }
}

struct TimeInputKeyPreviews: PreviewProvider {
    static var previews: some View {
        let model = TimeInputKeyboardModel()
        Group {
            TimeInputKeyView(model: model, digit: "3")
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
