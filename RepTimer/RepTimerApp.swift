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
    @StateObject var controller: StopWatchesController = StopWatchesController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(controller: controller)
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
