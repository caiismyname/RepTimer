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
    @StateObject private var timersController = TimersController()
    @StateObject private var stopwatchesController = StopwatchesController()
    @Environment(\.scenePhase) private var scenePhase // Used for detecting when this scene is backgrounded and isn't currently visible.
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                timersController: timersController,
                stopwatchesController: stopwatchesController
            )
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    stopwatchesController.save()
                    timersController.saveDownUpTimer()
                }
            }
            .onAppear {
                stopwatchesController.loadStopwatches { result in
                    switch result {
                    case .success (let values):
                        self.stopwatchesController.stopwatches = values["stopwatches"]!
                        self.stopwatchesController.pastStopwatches = values["pastStopwatches"]!
                        self.stopwatchesController.startAllTimers()
                        self.stopwatchesController.setAllResetCallbacks()
                    case .failure (let error):
                        fatalError(error.localizedDescription)
                    }
                }
                
                timersController.loadDownUpTimer { result in
                    print("loading DownUp")
                    switch result {
                    case .success(let values):
                        self.timersController.downupTimer = values["downupTimer"]!
                        self.timersController.downupTimer.startSystemTimers()
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
