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
        VStack(alignment: .leading) {
            if stopwatch.status != PeriodStatus.ended {  // Normal operation
                // Total time
                Text(stopwatch.status == PeriodStatus.paused
                     ? stopwatch.duration.formattedTimeTwoMilliLeadingZero
                     : stopwatch.duration.formattedTimeOneMilliLeadingZero)
                .font(.system(size: 40, weight: .regular , design: .monospaced))
                .minimumScaleFactor(0.01)
                
                // Current lap
                if let lap = stopwatch.currentLap() {
                    Text(lap.displayFormatted)
                    .font(Font.monospaced(.system(size: 70))())
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .padding(.leading, -6) // Visual alignment
                } else {
                    Text("00:00.00")
                    .font(.system(size: 70, weight: .regular , design: .monospaced))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                }
            } else { // Historical view
                // Start datetime
                Text(stopwatch.createDate.formatted())
                .font(.system(size: 25, weight: .regular , design: .monospaced))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                
                // Total time
                Text(stopwatch.duration.formattedTimeTwoMilliLeadingZero)
                .font(Font.monospaced(.system(size: 70))())
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            }
            
            Spacer()
            
            // List of laps
            Group {
                HStack {
                    Text("Lap")
                    Spacer()
                    Text("Lap Time")
                    Spacer()
                    Text("Cumulative")
                }
                .font(.system(size: 20, weight: .bold , design: .monospaced))
                
                List(stopwatch.reversedLaps().indices, id: \.self) { index in
                    HStack {
                        Text("\(stopwatch.reversedLaps().count - index)")
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].displayFormatted)
                        Spacer()
                        Text(stopwatch.reversedLaps()[index].cumulativeTime == 0.0
                             ? (stopwatch.status == PeriodStatus.ended
                                    ? stopwatch.duration.formattedTimeTwoMilliLeadingZero
                                    : "        "
                                )
                             :  stopwatch.reversedLaps()[index].cumulativeTime.formattedTimeTwoMilliLeadingZero)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                }
                .listStyle(.plain)
            }
            .font(.system(size: 20, weight: .regular , design: .monospaced))
            .minimumScaleFactor(0.01)
            
            StopWatchControlsView(stopwatch: stopwatch)
        }
    }
}

struct RepTimeView_Previews: PreviewProvider {
    @State var stopwatch = SingleStopWatch()
    static var previews: some View {
        Group {
            SingleStopWatchView(stopwatch: SingleStopWatch())
//                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

