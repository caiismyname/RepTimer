//
//  TabView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TabContainerView: View {
    @ObservedObject var timelineController: TimelineController
    @ObservedObject var stopwatchesController: StopwatchesController
    @StateObject var downUpTimerController = DownUpTimer()
    
    var body: some View {
        TabView {
            StopWatchContainerView(controller: stopwatchesController)
            .tabItem {
                Image(systemName: "stopwatch")
                Text("Stopwatch")
            }
//            TimerContainerView(timelineController: timelineController)
//            .tabItem {
//                Image(systemName: "timer")
//                Text("Timers")
//            }
            DownUpTimerView(controller: downUpTimerController)
                .tabItem {
                    Image(systemName: "arrow.counterclockwise.circle")
                    Text("Repeat TImer")
                }
        }
        .font(.system(size: 30))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineController = TimelineController()
        let stopwatchesController = StopwatchesController()
        Group {
            TabContainerView(
                timelineController: timelineController,
                stopwatchesController: stopwatchesController
            )
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 Pro")
        }
    }
}

