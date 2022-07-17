//
//  TabView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TabContainerView: View {
    @ObservedObject var timersController: TimersController
    @ObservedObject var stopwatchesController: StopwatchesController
    
    var body: some View {
        TabView {
            StopWatchContainerView(controller: stopwatchesController)
            .tabItem {
                Image(systemName: "stopwatch")
                Text("Stopwatch")
            }
            TimerContainerView(timelineController: timersController)
            .tabItem {
                Image(systemName: "timer")
                Text("Timers")
            }
            DownUpTimerView(controller: timersController.downupTimer)
                .tabItem {
                    Image(systemName: "arrow.counterclockwise.circle")
                    Text("Repeat Timer")
                }
        }
        .font(.system(size: 30))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineController = TimersController()
        let stopwatchesController = StopwatchesController()
        Group {
            TabContainerView(
                timersController: timelineController,
                stopwatchesController: stopwatchesController
            )
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 Pro")
        }
    }
}

