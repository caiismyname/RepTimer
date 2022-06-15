//
//  LapModel.swift
//  RepTimer
//
//  Created by David Cai on 6/5/22.
//

import Foundation
import SwiftUI

class Lap: Period, Identifiable {
    var lastPollTime: Date
    var duration: TimeInterval
    var status: PeriodStatus
    var cumulativeTime: TimeInterval
    
    init(startTime: Date) {
        self.lastPollTime = startTime
        self.duration = TimeInterval(0)
        self.status = PeriodStatus.inactive
        self.cumulativeTime = TimeInterval(0)
    }
    
    func update() {
        // Only update if the period is active
        guard status == PeriodStatus.active else {
            return
        }
     
        // Recalculate `duration` for the stopwatch
        let now = Date()
        let delta = now.timeIntervalSince(lastPollTime)
        duration += delta
        
        // Reset lastPollTime
        lastPollTime = now
    }
    
    func start() {
        lastPollTime = Date()
        status = PeriodStatus.active
    }
    
    func pause() {
        status = PeriodStatus.paused
    }
    
    func resume() {
        lastPollTime = Date()
        status = PeriodStatus.active
    }
}
