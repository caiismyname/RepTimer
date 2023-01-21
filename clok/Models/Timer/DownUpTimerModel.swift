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
    case active
    case paused
}

enum DownUpTimerDirection: Codable {
    case counting_down
    case counting_up
}

class DownUpTimer: ObservableObject, Codable {
    @Published var timer = SingleTimer(timeRemaining: 100, name: "", repeatAlert: false) // Placeholder timer, will be replaced when `reset()` is called
    @Published var stopwatch = SingleStopWatch()
    @Published var status = DownUpTimerStatus.inactive
    @Published var startingDirection = DownUpTimerDirection.counting_down
    @Published var currentDirection = DownUpTimerDirection.counting_down
    @Published var timerDuration = 0.0
    @Published var keyboard = TimeInputKeyboardModel(value: 0.0)
    @Published var cycleCount = 0
    @Published var totalDurationStopwatch = SingleStopWatch()
    
    init() {
        // Need a blank init b/c the Codable init overrides
    }
    
    func nextPhase() {
        guard self.timerDuration != 0.0 else {
            self.status = .inactive
            return
        }
        
        // On start
        if cycleCount == 0 {
            self.status = .active
            self.currentDirection = self.startingDirection == .counting_up ? .counting_down : .counting_up // Initialize to opposite so upcoming code switches the state to the correct one
            if self.totalDurationStopwatch.status != .active {
                self.totalDurationStopwatch.start()
            }
        }
        
        // Resume from pause
        if status == .paused {
            if currentDirection == .counting_up {
                self.stopwatch.resume()
            } else if currentDirection == .counting_down {
                self.timer.start()
            }
            
            self.totalDurationStopwatch.resume()
            self.status = .active
        } else if currentDirection == .counting_up { // Currently counting up, switch to down
            self.stopwatch.pause()
            
            initTimer()
            self.timer.start()
            self.currentDirection = .counting_down
            
            checkAndIncrementTotalCycleCount()
        } else if currentDirection == .counting_down { // Currently counting down, switch to up
            self.timer.stop() // This removes the sound/notif from the current timer, which is only necessary if we're stopping it early
            doneTimerCallback() // This function will increment the totalCycleCount for us
        }
    }
    
    private func checkAndIncrementTotalCycleCount() {
        // Maintain session counter (only count when we cycle around)
        if self.currentDirection == self.startingDirection {
            self.cycleCount = self.cycleCount + 1
        }
    }
    
    func pause() {
        if self.currentDirection == .counting_up {
            self.stopwatch.pause()
        } else if self.currentDirection == .counting_down {
            self.timer.pause()
        }
        
        self.totalDurationStopwatch.pause()
        self.status = .paused
    }
    
    func reset() {
        self.status = .inactive
        self.timer.stop()
        self.stopwatch = SingleStopWatch()  // Stopwatch's own reset func is mostly just a callback handler. Easier to just replace it here
        self.cycleCount = 0
        self.totalDurationStopwatch = SingleStopWatch()
    }
    
    func initTimer() {
        self.timer = SingleTimer(timeRemaining: self.timerDuration, name: "", repeatAlert: false)
        setTimerCallback()
    }
    
    func setTimerCallback() {
        self.timer.doneCallback = {self.doneTimerCallback()}
    }
    
    func doneTimerCallback() {
        self.stopwatch = SingleStopWatch() // "reset" the stopwatch
        self.stopwatch.start()
        self.currentDirection = .counting_up
        
        checkAndIncrementTotalCycleCount()
    }
    
    func startSystemTimers() {
        keyboard.setValue(value: timerDuration)
        
        guard self.status != DownUpTimerStatus.inactive else {
            return
        }
        
        if Date() > timer.scheduledEndTime { // Timer has already finished
            self.currentDirection = .counting_up
            self.stopwatch.start(startTime: timer.scheduledEndTime)
//            if self.status == DownUpTimerStatus.counting_down {
//                self.status = DownUpTimerStatus.counting_up
//                self.stopwatch.start(startTime: timer.scheduledEndTime)
//            } else {
//                self.stopwatch.start()
//            }
        } else {
            self.currentDirection = .counting_down
            setTimerCallback()
            self.timer.startSystemTimer()
        }
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
