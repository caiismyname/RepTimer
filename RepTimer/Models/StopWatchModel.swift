//
//  RepModel.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI


class StopWatch: Period, ObservableObject {
    var lastPollTime: Date
    @Published var duration: TimeInterval
    @Published var status: PeriodStatus
    
    @Published var laps: [Lap] = []
    var timer: Timer = Timer()
    
    enum CodingKeys : String, CodingKey {
        case startTime
    }
    
    init() {
        // Set a repeating timer to update the durations
        self.lastPollTime = Date()
        self.duration = TimeInterval(0)
        self.status = PeriodStatus.inactive
        newLap(startTime: self.lastPollTime) // Start a new lap along with the overall timer
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.1),
            target: self,
            selector: (#selector(update)),
            userInfo: nil,
            repeats: true
        )
    }
//
//    required convenience init(from decoder: Decoder) throws {
//        // TODO Broken
//        self.init()
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let decodedStartTime = try values.decode(Date.self, forKey: .startTime)
//        print(decodedStartTime)
//
//        self.timerStartTime = decodedStartTime
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(timerStartTime, forKey: .startTime)
//    }
    
    
    func currentLap() -> Lap {
        return laps.last!
    }
    
    func newLap(startTime: Date = Date()) {
        laps.last?.status = PeriodStatus.inactive
        laps.append(Lap(startTime: startTime))
        laps.last?.status = PeriodStatus.active
    }
    

    @objc func update() {
        
        // Only update if the period is active
        guard status == PeriodStatus.active else {
            return
        }
        
        // Don't support times greater than a day
//        if duration >= 60 * 60 * 24  {
//            lastPollTime = Date()
//        }
        
        // Recalculate `duration` for the stopwatch
        let now = Date()
        let delta = now.timeIntervalSince(lastPollTime)
        duration += delta
        
        // Reset lastPollTime
        lastPollTime = now
        
        // Recalculate `duration` for the current lap
        currentLap().update()
    }
  
    func start() {
        lastPollTime = Date()
        status = PeriodStatus.active
        
        newLap(startTime: lastPollTime)
        currentLap().start()
    }
    
    func pause() {
        status = PeriodStatus.paused
        
        currentLap().pause()
    }
    
    func resume() {
        lastPollTime = Date()
        status = PeriodStatus.active
        
        currentLap().resume()
    }
    
    func reset() {
        status = PeriodStatus.inactive
        duration = TimeInterval(0)
        laps = []
    }
}
