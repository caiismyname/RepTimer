//
//  TabView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TabContainerView: View {
    @StateObject var stopwatchController: StopWatchesController
    
    var body: some View {
        TabView {
            StopWatchContainerView(controller: stopwatchController)
                .tabItem {
                    Image(systemName: "stopwatch")
                        .font(.system(size: 30))
                    Text("Stopwatch")
                }
            TimerContainerView()
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
        let stopwatchController = StopWatchesController()
        Group {
            TabContainerView(stopwatchController: stopwatchController)
                .previewInterfaceOrientation(.portrait)
        }
    }
}

