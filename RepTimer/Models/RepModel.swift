//
//  RepModel.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI


class Rep: ObservableObject, Codable {
    @Published var startTime: Date
    @Published var repDuration: TimeInterval = TimeInterval(0)
    var timer: Timer = Timer()
    
    enum CodingKeys : String, CodingKey {
        case startTime
    }
    
    init() {
        // Set a repeating timer to update `repDuration`
        self.startTime = Date()
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.1),
            target: self,
            selector: (#selector(updateTimer)),
            userInfo: nil,
            repeats: true
        )
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let decodedStartTime = try values.decode(Date.self, forKey: .startTime)
        print(decodedStartTime)
        
        self.startTime = decodedStartTime
        print(self.startTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
    }
    
    func repDurationFormatted() -> String {
        print(startTime)
        let displayHours = repDuration.hours == 0 ? "" : repDuration.hours.withLeadingZero + ":"
        return String(
            displayHours + repDuration.minutes.withLeadingZero + ":" + repDuration.seconds.withLeadingZero
        )
    }

    @objc func updateTimer() {
        // Don't support times greater than a day
        if repDuration >= 60 * 60 * 24  {
            startTime = Date()
        }
        
        // Recalculate `repDuration`
        let timeInterval: TimeInterval = Date.now.timeIntervalSince(startTime)
        repDuration = timeInterval
    }
    
    func restart() {
        startTime = Date()
    }
    
    func pause() {
        
    }
}
