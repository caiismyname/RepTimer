//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//


import Foundation
import SwiftUI


struct StopWatchView: View {
    @StateObject var stopwatch: StopWatch
    let colonWidth = 20

    var body: some View {
        VStack {
            Spacer()
            Text(stopwatch.currentLap().displayFormatted)
                .font(Font.monospaced(.system(size: 500))())
                .minimumScaleFactor(0.001)
                .padding()
            Text(stopwatch.displayFormatted)
                .font(Font.monospaced(.system(size:50))())
                .minimumScaleFactor(1)
                .padding()
            Spacer()
            Button(action: {stopwatch.newLap()}) {
                Text("Lap")
                    .font(Font.monospaced(.system(size:100))())
                    .minimumScaleFactor(1)
                    .padding(20)
                    .foregroundColor(Color.white)
                    .background(Color.black)
            }.cornerRadius(12)
            Button(action: {stopwatch.reset()}) {
                Text("Reset")
                    .font(Font.monospaced(.system(size:20))())
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
    let stopwatch = StopWatch()
    Group {
        StopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
    }
  }
}

