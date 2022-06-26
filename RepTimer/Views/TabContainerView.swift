//
//  TabView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TabContainerView: View {
    @StateObject var timelineController: TimelineController
    
    var body: some View {
        TabView {
            StopWatchContainerView()
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
        Group {
            TabContainerView(
                timelineController: timelineController)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}

