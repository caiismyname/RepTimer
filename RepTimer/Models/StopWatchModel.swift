//
//  RepModel.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI


class StopWatch: Period, ObservableObject {
    @Published var startTime: Date
    @Published var duration: TimeInterval
    @Published var isActive: Bool
    
    @Published var laps: [Lap] = []
    var timer: Timer = Timer()
    
    enum CodingKeys : String, CodingKey {
        case startTime
    }
    
    init() {
        // Set a repeating timer to update the durations
        self.startTime = Date()
        self.duration = TimeInterval(0)
        self.isActive = true
        newLap(startTime: self.startTime) // Start a new lap along with the overall timer
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.1),
            target: self,
            selector: (#selector(updateTimer)),
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

    @objc func updateTimer() {
        // Don't support times greater than a day
        if duration >= 60 * 60 * 24  {
            startTime = Date()
        }
        
        // Recalculate `duration` for the stopwatch
        duration = Date.now.timeIntervalSince(startTime)
        
        // Recalculate `duration` for the current lap
        let currentLap = laps.last
        currentLap?.duration = Date.now.timeIntervalSince(currentLap!.startTime)
    }
    
    func currentLap() -> Lap {
        return laps.last!
    }
    
    func reset() {
        startTime = Date()
        laps = []
        newLap(startTime: startTime)
    }
    
    func newLap(startTime: Date = Date()) {
        laps.last?.isActive = false
        laps.append(Lap(startTime: startTime))
    }
    
    func pause() {
        
    }
}
