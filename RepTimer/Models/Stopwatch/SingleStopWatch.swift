//
//  RepModel.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI


class SingleStopWatch: Period, ObservableObject, Identifiable, Codable {
    var id: UUID = UUID()
    var lastPollTime: Date
    @Published var duration: TimeInterval
    @Published var status: PeriodStatus
    
    @Published var laps: [Lap] = []
    var timer: Timer = Timer()
    
    enum CodingKeys : String, CodingKey {
        case startTime
    }
    
    init() {
        self.lastPollTime = Date()
        self.duration = TimeInterval(0)
        self.status = PeriodStatus.inactive
    }
    
// MARK: — Behavior funcs
    
    func currentLap() -> Lap? {
        return laps.last
    }
    
    func reversedLaps() -> [Lap] {
        return laps.reversed()
    }
    
    func newLap(startTime: Date = Date()) {
        laps.last?.status = PeriodStatus.inactive
        laps.last?.cumulativeTime = self.duration
        laps.append(Lap(startTime: startTime))
        laps.last?.status = PeriodStatus.active
    }

    @objc func update() {
        
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
        
        // Recalculate `duration` for the current lap
        if let lap = currentLap() {
            lap.update()
        }
    }
  
    func start() {
        lastPollTime = Date()
        status = PeriodStatus.active
        
        newLap(startTime: lastPollTime)
        if let lap = currentLap() {
            lap.start()
        }
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.001),
            target: self,
            selector: (#selector(update)),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func pause() {
        status = PeriodStatus.paused
        
        if let lap = currentLap() {
            lap.pause()
        }
    }
    
    func resume() {
        lastPollTime = Date()
        status = PeriodStatus.active
        
        if let lap = currentLap() {
            lap.resume()
        }
    }
    
    func reset() {
        status = PeriodStatus.inactive
        duration = TimeInterval(0)
        laps = []
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case id
        case lastPollTime
        case duration
        case status
        case laps
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lastPollTime, forKey: .lastPollTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(status, forKey: .status)
        try container.encode(laps, forKey: .laps)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        lastPollTime = try values.decode(Date.self, forKey: .lastPollTime)
        duration = try values.decode(TimeInterval.self, forKey: .duration)
        status = try values.decode(PeriodStatus.self, forKey: .status)
        laps = try values.decode([Lap].self, forKey: .laps)
        
        if status != PeriodStatus.inactive {
            startTimer()
        }
    }
}
