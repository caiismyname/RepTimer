//
//  ContentView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timelineController: TimelineController
    @ObservedObject var stopwatchesController: StopwatchesController
    
    var body: some View {
        TabContainerView(
            timelineController: timelineController,
            stopwatchesController: stopwatchesController
        )
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = TimelineController()
        let stopwatches = StopwatchesController()
        ContentView(
            timelineController: timeline,
            stopwatchesController: stopwatches
        )
        .previewDevice("iPhone 13 Pro")
    }
}
