//
//  StopWatchControlsView.swift
//  RepTimer
//
//  Created by David Cai on 6/15/22.
//

import Foundation
import SwiftUI


struct StopWatchControlsView: View {
    @StateObject var stopwatch: SingleStopWatch
    let buttonPadding = CGFloat(10)

    var body: some View {
        if stopwatch.status == PeriodStatus.inactive {
            HStack {
                Spacer()
                Button(action: {stopwatch.reset()}) {
                    Text("Reset").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(12)
                Button(action: {stopwatch.start()}) {
                    Text("Start").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(12)
                Spacer()
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                .buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
        } else if stopwatch.status == PeriodStatus.active {
            HStack {
                Spacer()
                Button(action: {stopwatch.pause()}) {
                    Text("Pause").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(12)
                Button(action: {stopwatch.newLap()}) {
                    Text("Lap").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(12)
                Spacer()
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                .buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
        } else if stopwatch.status == PeriodStatus.paused {
            HStack {
                Spacer()
                Button(action: {stopwatch.reset()}) {
                    Text("Reset").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(12)
                Button(action: {stopwatch.resume()}) {
                    Text("Resume").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(12)
                Spacer()
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                .buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
        }
    }
}

struct StopWatchControlsView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = SingleStopWatch()
    Group {
        StopWatchControlsView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}

