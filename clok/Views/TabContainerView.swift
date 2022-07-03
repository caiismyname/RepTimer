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
    
    var body: some View {
        TabView {
            StopWatchContainerView(controller: stopwatchesController)
            .tabItem {
                Image(systemName: "stopwatch")
                .font(.system(size: 30))
                Text("Stopwatch")
            }
            TimerContainerView(timelineController: timelineController)
            .tabItem {
                Image(systemName: "timer")
                .font(.system(size: 30))
                Text("Timer")
            }
        }
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
            .previewDevice("iPhone 13 Pro")
        }
    }
}

