//
//  TimerTimelineEntry.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

struct TimelineEntryView: View {
    @StateObject var timer: SingleTimer
    let proxy: GeometryProxy
    let verticalFidelity: Double
    let bottomDuration: Double
    
    func computeWidth() -> Double {
        return (proxy.size.width / 1.5)
    }
    
    func computeHeight() -> Double {
        return (proxy.size.height / verticalFidelity)
    }
    
    func computeYPos() -> Double {
        return (timer.timeRemaining / bottomDuration) * (proxy.size.height - computeHeight()) + (computeHeight() / 2)
    }

    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.white))
                .cornerRadius(12)
                .frame(width: computeWidth(), height: computeHeight())
            HStack {
                if (timer.name != "") {
                    Text(timer.name)
                        .font(Font.monospaced(.system(size:20))())
                        .foregroundColor(Color.black)
                }
                if (timer.status == TimerStatus.active) {
                    // Round up so time hits 0:00 when the pill hits the top of the screen
                    Text(timer.timeRemaining.formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond)
                        .font(Font.monospaced(.system(size:20))())
                        .foregroundColor(Color.black)
                } else if (timer.status == TimerStatus.ended) {
                    Text(timer.timeRemaining.formattedTimeNoMilliNoLeadingZero)
                        .font(Font.monospaced(.system(size:20))())
                        .foregroundColor(Color.black)
                }
            }.padding()
        }.position(
            x: proxy.size.width / 2,
            y: computeYPos()
        )
    }
}

struct TimelineEntryView_Previews: PreviewProvider {
  static var previews: some View {
      let timer = SingleTimer(timeRemaining: 4, name: "cookies")
    
    Group {
        ZStack {
            GeometryReader{ proxy in
                TimelineEntryView(
                    timer: timer,
                    proxy: proxy,
                    verticalFidelity: 20.0,
                    bottomDuration: 4.0
                )
                    
            }.border(Color.red)
        }
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
            .preferredColorScheme(.dark)
    }
  }
}
