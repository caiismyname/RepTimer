//
//  RepTimerApp.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

@main
struct RepTimerApp: App {
//    @StateObject private var store = RepStore()
    @StateObject private var timelineController = TimelineController()
    @StateObject private var stopwatchesController = StopwatchesController()
    @Environment(\.scenePhase) private var scenePhase // Used for detecting when this scene is backgrounded and isn't currently visible.
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                timelineController: timelineController,
                stopwatchesController: stopwatchesController
            )
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    stopwatchesController.save()
                }
            }
            .onAppear {
                stopwatchesController.loadStopwatches { result in
                    print(result)
                    switch result {
                    case .success (let values):
                        self.stopwatchesController.stopwatches = values["stopwatches"]!
                        self.stopwatchesController.pastStopwatches = values["pastStopwatches"]!
                        self.stopwatchesController.startAllTimers()
                    case .failure (let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }
//                RepStore.save(rep: store.stopwatch) {result in
//                    if case .failure(let error) = result {
//                         fatalError(error.localizedDescription)
//                     }
//                }
//
//            .onAppear {
//                RepStore.load{ result in
//                    switch result {
//                        case .failure(let error):
//                            fatalError(error.localizedDescription)
//                        case .success(let rep):
//                            store.stopwatch = rep
//                    }
//                }
//            }
        }
    }
}
