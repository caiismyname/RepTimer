//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//


import Foundation
import SwiftUI


struct RepTimeView: View {
    @StateObject var rep: Rep
    let colonWidth = 20

    var body: some View {
        VStack {
            Spacer()
            Text(rep.repDurationFormatted())
                .font(Font.monospaced(.system(size: 500))())
                .minimumScaleFactor(0.001)
                .padding()
            Spacer()
            Button(action: {rep.restart()}) {
                Text("Reset")
                    .font(Font.monospaced(.system(size:100))())
                    .minimumScaleFactor(1)
                    .padding(20)
                    .foregroundColor(Color.white)
                    .background(Color.black)
            }.cornerRadius(12)
            Spacer()
      }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
  }
}

struct RepTimeView_Previews: PreviewProvider {
  static var previews: some View {
    let rep = Rep()
    Group {
        RepTimeView(rep: rep)
            .previewInterfaceOrientation(.portrait)
    }
  }
}

