//
//  StopWatchesController.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI


class StopWatchesController: ObservableObject {
    @Published var stopwatches: [SingleStopWatch] = []
    
    init() {
        addStopwatch()
    }
    
    func addStopwatch() {
        let newStopwatch = SingleStopWatch()
        stopwatches.append(newStopwatch)
    }
    
    func deleteStopwatch(index: Int) {
        stopwatches.remove(at: index)
    }
    
    func getStopwatch(id: UUID) -> SingleStopWatch? {
        for stopwatch in self.stopwatches {
            if (stopwatch.id == id) {
                return stopwatch
            }
        }
        
        return nil
    }
}
