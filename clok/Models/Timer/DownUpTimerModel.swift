//
//  DownUpTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import UserNotifications
import AVFoundation

enum DownUpTimerStatus: Codable {
    case inactive
    case counting_down
    case counting_up
}

class DownUpTimer: ObservableObject, Codable {
    @Published var timer = SingleTimer(timeRemaining: 100, name: "") // Placeholder timer, will be replaced when `reset()` is called
    @Published var stopwatch = SingleStopWatch()
    @Published var status = DownUpTimerStatus.inactive
    @Published var timerDuration = 0.0
    @Published var keyboard = TimeInputKeyboardModel(value: 0.0)
    
    init() {
    }
    
    // Start and reset technically do the same thing
    func reset() {
        guard self.timerDuration != 0.0 else {
            self.status = DownUpTimerStatus.inactive
            return
        }
        
        initTimer()
        timer.start()
        stopwatch = SingleStopWatch() // Stopwatch's own reset func is mostly just a callback handler. Easier to just replace it here
        self.status = DownUpTimerStatus.counting_down
    }
    
    func stop() {
        self.status = DownUpTimerStatus.inactive
        timer.stop()
        stopwatch = SingleStopWatch()  // Stopwatch's own reset func is mostly just a callback handler. Easier to just replace it here
    }
    
    func initTimer() {
        timer = SingleTimer(timeRemaining: self.timerDuration, name: "")
        setTimerCallback()
    }
    
    func doneTimerCallback() {
        self.status = DownUpTimerStatus.counting_up
        stopwatch.start()
    }
    
    func startSystemTimers() {
        keyboard.setValue(value: timerDuration)
        
        guard self.status != DownUpTimerStatus.inactive else {
            return
        }
        
        if Date() > timer.scheduledEndTime {
            if self.status == DownUpTimerStatus.counting_down {
                self.status = DownUpTimerStatus.counting_up
                self.stopwatch.start(startTime: timer.scheduledEndTime)
            } else {
                self.stopwatch.start()
            }
        } else {
            self.status = DownUpTimerStatus.counting_down
            setTimerCallback()
            self.timer.startSystemTimer()
        }
    }
    
    func setTimerCallback() {
        self.timer.doneCallback = {self.doneTimerCallback()}
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case timer
        case stopwatch
        case status
        case timerDuration
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(timer, forKey: .timer)
        try container.encode(stopwatch, forKey: .stopwatch)
        try container.encode(status, forKey: .status)
        try container.encode(timerDuration, forKey: .timerDuration)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        timer = try values.decode(SingleTimer.self, forKey: .timer)
        stopwatch = try values.decode(SingleStopWatch.self, forKey: .stopwatch)
        status = try values.decode(DownUpTimerStatus.self, forKey: .status)
        timerDuration = try values.decode(TimeInterval.self, forKey: .timerDuration)
    }
}
