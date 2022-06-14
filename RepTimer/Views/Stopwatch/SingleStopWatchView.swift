//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//


import Foundation
import SwiftUI


struct SingleStopWatchView: View {
    @StateObject var stopwatch: StopWatch
    let colonWidth = 20

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(stopwatch.displayFormatted)
                    .font(Font.monospaced(.system(size:40))())
                    .minimumScaleFactor(1)
                    .padding([.leading, .top], 30)
                if let lap = stopwatch.currentLap() {
                    Text(lap.displayFormatted)
                        .font(Font.monospaced(.system(size: 70))())
                        .minimumScaleFactor(1)
                        .padding(.leading, 26)
                } else {
                    Text("00:00.00")
                        .font(Font.monospaced(.system(size: 70))())
                        .minimumScaleFactor(1)
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
                        Text(stopwatch.reversedLaps()[index].cumulativeTime == 0.0 ? "        " :  stopwatch.reversedLaps()[index].cumulativeTime.formattedTime)
                            .font(Font.monospaced(.system(size:20))())
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .leading)
                }
                    .listStyle(.plain)
                    .padding([.leading, .trailing], 15)
            }
            if stopwatch.status == PeriodStatus.inactive {
                HStack {
                    Spacer()
                    Button(action: {stopwatch.reset()}) {
                        Text("Reset").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.start()}) {
                        Text("Start").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Spacer()
                }
            } else if stopwatch.status == PeriodStatus.active {
                HStack {
                    Spacer()
                    Button(action: {stopwatch.pause()}) {
                        Text("Pause").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.newLap()}) {
                        Text("Lap").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Spacer()
                }
            } else if stopwatch.status == PeriodStatus.paused {
                HStack {
                    Spacer()
                    Button(action: {stopwatch.reset()}) {
                        Text("Reset").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.resume()}) {
                        Text("Resume").font(.system(size:20))
                            .frame(maxWidth: .infinity)
                    }
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Spacer()
                }
            }
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
  }
}

struct RepTimeView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = StopWatch()
    Group {
        SingleStopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
    }
  }
}

