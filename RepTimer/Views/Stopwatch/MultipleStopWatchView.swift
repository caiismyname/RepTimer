//
//  MultipleStopWatchView.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI

// This is how a single StopWatch looks when there are multiple of them in a container.
struct MultipleStopWatchView: View {
    @StateObject var stopwatch: StopWatch
    let secondaryTextSize = CGFloat(18)
    let buttonPadding = CGFloat(10)
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(stopwatch.displayFormatted)
                .font(Font.monospaced(.system(size: 50))())
                .minimumScaleFactor(0.01)
            Text("\(stopwatch.laps.count) laps")
                .font(Font.monospaced(.system(size: secondaryTextSize))())
                .minimumScaleFactor(1)
                .padding(.leading, 7)

            if stopwatch.status == PeriodStatus.inactive {
                HStack {
                    Button(action: {stopwatch.reset()}) {
                        Text("Reset").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.start()}) {
                        Text("Start").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                }.buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
            } else if stopwatch.status == PeriodStatus.active {
                HStack {
                    Button(action: {stopwatch.pause()}) {
                        Text("Pause").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.newLap()}) {
                        Text("Lap").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                }.buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
            } else if stopwatch.status == PeriodStatus.paused {
                HStack {
                    Button(action: {stopwatch.reset()}) {
                        Text("Reset").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                    Button(action: {stopwatch.resume()}) {
                        Text("Resume").font(.system(size:secondaryTextSize))
                            .frame(maxWidth: .infinity)
                    }
                        .padding(buttonPadding)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(12)
                }.buttonStyle(BorderlessButtonStyle()) // This button style is what enables multiple button in a ListView to be tappable. Dunno why.
            }
        }
    }
}

struct MultipleStopWatchView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = StopWatch()
    Group {
        MultipleStopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}

