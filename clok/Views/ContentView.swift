//
//  ContentView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timersController: TimersController
    @ObservedObject var stopwatchesController: StopwatchesController
    
    var body: some View {
        TabContainerView(
            timersController: timersController,
            stopwatchesController: stopwatchesController
        )
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let timers = TimersController()
        let stopwatches = StopwatchesController()
        ContentView(
            timersController: timers,
            stopwatchesController: stopwatches
        )
        .previewDevice("iPhone 13 Pro")
    }
}
