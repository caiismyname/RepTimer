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
//    @AppStorage("selectedTabIndex") var selectedTabIndex: Int = 0
    let buttonSize = Sizes()
    
    var body: some View {
//        TabView(selection: $selectedTabIndex) {
        TabView {
            StopWatchContainerView(controller: stopwatchesController)
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Stopwatch")
                }
//                .tag(0)
            
            TimerTimelineView(controller: timersController)
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timers")
                }
//                .tag(1)
            
            DownUpTimerView(controller: timersController.downupTimer)
                .tabItem {
                    Image(systemName: "arrow.counterclockwise.circle")
                    Text("Repeat Timer")
                }
//                .tag(2)
        }
        .font(.system(size: buttonSize.fontSize))
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

