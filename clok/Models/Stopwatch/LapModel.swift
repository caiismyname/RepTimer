//
//  LapModel.swift
//  RepTimer
//
//  Created by David Cai on 6/5/22.
//

import Foundation
import SwiftUI

class Lap: Period, Identifiable, Codable {
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
    
    // MARK: — Behavior funcs
    
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
    
    func start(startTime: Date = Date()) {
        lastPollTime = startTime
        status = PeriodStatus.active
    }
    
    func pause() {
        status = PeriodStatus.paused
    }
    
    func resume() {
        lastPollTime = Date()
        status = PeriodStatus.active
    }
    
    // MARK: — Codable
    
    private enum CoderKeys: String, CodingKey {
        case lastPollTime
        case duration
        case status
        case cumulativeTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(lastPollTime, forKey: .lastPollTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(status, forKey: .status)
        try container.encode(cumulativeTime, forKey: .cumulativeTime)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        lastPollTime = try values.decode(Date.self, forKey: .lastPollTime)
        duration = try values.decode(TimeInterval.self, forKey: .duration)
        status = try values.decode(PeriodStatus.self, forKey: .status)
        cumulativeTime = try values.decode(TimeInterval.self, forKey: .cumulativeTime)
    }
}
