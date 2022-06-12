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
            VStack(alignment: .leading) {
                Text(stopwatch.currentLap().displayFormatted)
                    .font(Font.monospaced(.system(size: 500))())
                    .minimumScaleFactor(0.001)
                Text(stopwatch.displayFormatted)
                    .font(Font.monospaced(.system(size:40))())
                    .minimumScaleFactor(1)
            }
            Spacer()
            if stopwatch.status == PeriodStatus.inactive {
                HStack {
                    Button(action: {stopwatch.start()}) {
                        Button(action: {stopwatch.reset()}) {
                            Text("Reset")
                                .font(Font.monospaced(.system(size:20))())
                                .minimumScaleFactor(1)
                                .padding(20)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                        }.cornerRadius(12)
                        Text("Start")
                            .font(Font.monospaced(.system(size:20))())
                            .minimumScaleFactor(1)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    }.cornerRadius(12)
                }
            } else if stopwatch.status == PeriodStatus.active {
                HStack {
                    Button(action: {stopwatch.newLap()}) {
                        Button(action: {stopwatch.pause()}) {
                            Text("Pause")
                                .font(Font.monospaced(.system(size:20))())
                                .minimumScaleFactor(1)
                                .padding(20)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                        }.cornerRadius(12)
                        Text("Lap")
                            .font(Font.monospaced(.system(size:20))())
                            .minimumScaleFactor(1)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    }.cornerRadius(12)
                }
            } else if stopwatch.status == PeriodStatus.paused {
                HStack {
                    Button(action: {stopwatch.resume()}) {
                        Button(action: {stopwatch.reset()}) {
                            Text("Reset")
                                .font(Font.monospaced(.system(size:20))())
                                .minimumScaleFactor(1)
                                .padding(20)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                        }.cornerRadius(12)
                        Text("Resume")
                            .font(Font.monospaced(.system(size:20))())
                            .minimumScaleFactor(1)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    }.cornerRadius(12)
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
        StopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
    }
  }
}

