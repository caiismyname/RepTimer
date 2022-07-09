//
//  StopWatchControlsView.swift
//  RepTimer
//
//  Created by David Cai on 6/15/22.
//

import Foundation
import SwiftUI

struct StopWatchControlsView: View {
    @ObservedObject var stopwatch: SingleStopWatch
    @AppStorage(StopwatchSettings.SCREEN_LOCK.rawValue) var isScreenLock: Bool = false
    let buttonPadding = CGFloat(10)
    let haptic = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        if stopwatch.status == PeriodStatus.inactive {
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Reset").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(12)
                Button(action: {
                    if !isScreenLock {
                        stopwatch.start()
                        haptic.impactOccurred()
                    }
                }) {
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
                Button(action: {
                    if !isScreenLock {
                        stopwatch.newLap()
                        haptic.impactOccurred()
                    }
                }) {
                    Text("Lap").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(12)
                Button(action: {
                    if !isScreenLock {
                        stopwatch.pause()
                        haptic.impactOccurred()
                    }
                }) {
                    Text("Pause").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(12)
                Spacer()
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                .buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
        } else if stopwatch.status == PeriodStatus.paused {
            HStack {
                Spacer()
                Button(action: {
                    if !isScreenLock {
                        stopwatch.reset()
                        haptic.impactOccurred()
                    }
                }) {
                    Text("Reset").font(.system(size:20))
                        .frame(maxWidth: .infinity)
                }
                    .padding(buttonPadding)
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(12)
                Button(action: {
                    if !isScreenLock {
                        stopwatch.resume()
                        haptic.impactOccurred()
                    }
                }) {
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
        } else if stopwatch.status == PeriodStatus.ended {
            // No controls if the stopwatch has ended
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
            .preferredColorScheme(.dark)
    }
  }
}

