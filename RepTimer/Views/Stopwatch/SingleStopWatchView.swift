//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//


import Foundation
import SwiftUI


struct SingleStopWatchView: View {
    @StateObject var stopwatch: SingleStopWatch
    let colonWidth = 20

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Total time
                Text(stopwatch.displayFormatted)
                    .font(Font.monospaced(.system(size:40))())
                    .minimumScaleFactor(0.001)
                    .padding([.leading, .top], 30)
                
                // Current lap
                if let lap = stopwatch.currentLap() {
                    Text(lap.displayFormatted)
                        .font(Font.monospaced(.system(size: 70))())
                        .minimumScaleFactor(0.001)
                        .padding(.leading, 26)
                } else {
                    Text("00:00.00")
                        .font(Font.monospaced(.system(size: 70))())
                        .minimumScaleFactor(0.001)
                        .padding(.leading, 26)
                }
                List(stopwatch.reversedLaps().indices, id: \.self) { index in
                    HStack {
                        Text("Lap \(stopwatch.reversedLaps().count - index)")
                            .font(Font.monospaced(.system(size:20))())
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].displayFormatted)
                            .font(Font.monospaced(.system(size:20))())
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].cumulativeTime == 0.0 ? "        " :  stopwatch.reversedLaps()[index].cumulativeTime.formattedTimeTwoMilliLeadingZero)
                            .font(Font.monospaced(.system(size:20))())
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                }
                    .listStyle(.plain)
                    .padding([.leading, .trailing], 15)
            }
            StopWatchControlsView(stopwatch: stopwatch)
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
  }
}

struct RepTimeView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = SingleStopWatch()
    Group {
        SingleStopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}

