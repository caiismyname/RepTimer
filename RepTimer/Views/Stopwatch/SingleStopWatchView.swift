//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//


import Foundation
import SwiftUI


struct SingleStopWatchView: View {
    @ObservedObject var stopwatch: SingleStopWatch
    let colonWidth = 20

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Total time
                Text(stopwatch.duration.formattedTimeOneMilliLeadingZero)
                    .font(.system(size: 40, weight: .regular , design: .monospaced))
                    .minimumScaleFactor(0.01)
                    .padding(.leading, 10)
                
                // Current lap
                if let lap = stopwatch.currentLap() {
                    Text(lap.displayFormatted)
                        .font(Font.monospaced(.system(size: 70))())
                        .minimumScaleFactor(0.01)
                        .padding(.leading, 8)
                } else {
                    Text("00:00.00")
                        .font(.system(size: 200, weight: .regular , design: .monospaced))
                        .minimumScaleFactor(0.01)
                        .padding(.leading, 8)
                }
                Spacer()
                HStack {
                    Text("Lap")
                    Spacer()
                    Text("Lap Time")
                    Spacer()
                    Text("Cumulative")
                }
                .font(.system(size: 20, weight: .regular , design: .monospaced))
                .minimumScaleFactor(0.01)
                .padding([.leading, .trailing], 15)
                List(stopwatch.reversedLaps().indices, id: \.self) { index in
                    HStack {
                        Text("\(stopwatch.reversedLaps().count - index)")
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].displayFormatted)
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].cumulativeTime == 0.0 ? "        " :  stopwatch.reversedLaps()[index].cumulativeTime.formattedTimeTwoMilliLeadingZero)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                    .font(.system(size: 20, weight: .regular , design: .monospaced))
                    .minimumScaleFactor(0.01)
                }
                    .listStyle(.plain)
                    .padding([.leading, .trailing], 15)
            }
            StopWatchControlsView(stopwatch: stopwatch)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
  }
}

struct RepTimeView_Previews: PreviewProvider {
    @State var stopwatch = SingleStopWatch()
    static var previews: some View {
        Group {
            SingleStopWatchView(stopwatch: SingleStopWatch())
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

