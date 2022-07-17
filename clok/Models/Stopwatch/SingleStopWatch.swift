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
    var createDate: Date
    var resetCallback = {}
    @Published var duration: TimeInterval
    @Published var status: PeriodStatus
    @Published var laps: [Lap] = []
    var timer: Timer = Timer()
    
    enum CodingKeys : String, CodingKey {
        case startTime
    }
    
    init() {
        let now = Date()
        self.lastPollTime = now
        self.createDate = now
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
        laps.last?.status = PeriodStatus.ended
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
  
    func start(startTime: Date = Date()) {
        lastPollTime = startTime
        createDate = startTime
        status = PeriodStatus.active
        
        newLap(startTime: lastPollTime)
        if let lap = currentLap() {
            lap.start()
        }
        
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.01),
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
    
    // Doesn't actually clear the stopwatch, just triggers the reset handler. Built this way so the history page can save the stopwatch, then replace it in the list of active stopwatches
    func reset() {
        status = PeriodStatus.ended
        self.resetCallback()
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case id
        case lastPollTime
        case createDate
        case duration
        case status
        case laps
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(lastPollTime, forKey: .lastPollTime)
        try container.encode(createDate, forKey: .createDate)
        try container.encode(duration, forKey: .duration)
        try container.encode(status, forKey: .status)
        try container.encode(laps, forKey: .laps)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        lastPollTime = try values.decode(Date.self, forKey: .lastPollTime)
        createDate = try values.decode(Date.self, forKey: .createDate)
        duration = try values.decode(TimeInterval.self, forKey: .duration)
        status = try values.decode(PeriodStatus.self, forKey: .status)
        laps = try values.decode([Lap].self, forKey: .laps)
        
        if status != PeriodStatus.inactive {
            startTimer()
        }
    }
}
