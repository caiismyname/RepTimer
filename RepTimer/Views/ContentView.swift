//
//  ContentView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timelineController: TimelineController
//    @Environment(\.scenePhase) private var scenePhase
//    let saveAction: ()->Void
    
    var body: some View {
        TabContainerView(
            timelineController: timelineController
        ).preferredColorScheme(.dark)
        //        StopWatchContainerView(controller: controller)
//        .onChange(of: scenePhase) { phase in
//            if phase == .inactive { saveAction() }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let timeline = TimelineController()
        ContentView(timelineController: timeline)
            .previewDevice("iPhone 13 Pro")
    }
}
