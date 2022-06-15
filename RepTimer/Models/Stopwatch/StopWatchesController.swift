//
//  StopWatchesController.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI


class StopWatchesController: ObservableObject {
    @Published var stopwatches: [StopWatch] = []
    
    init() {
        addStopwatch()
    }
    
    func addStopwatch() {
        let newStopwatch = StopWatch()
        stopwatches.append(newStopwatch)
    }
    
    func deleteStopwatch(index: Int) {
        stopwatches.remove(at: index)
    }
}
