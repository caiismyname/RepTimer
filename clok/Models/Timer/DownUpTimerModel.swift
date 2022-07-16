//
//  DownUpTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import UserNotifications
import AVFoundation

enum DownUpTimerStatus {
    case inactive
    case counting_down
    case counting_up
}

class DownUpTimer: ObservableObject {
    @Published var timer = SingleTimer(timeRemaining: 100, name: "")
    @Published var stopwatch = SingleStopWatch()
    @Published var status = DownUpTimerStatus.inactive
    @Published var timerDuration = 0.0
    
    init() {
        timer = SingleTimer(timeRemaining: timerDuration, name: "")
        timer.doneCallback = {self.doneTimerCallback()}
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
        timer.doneCallback = {self.doneTimerCallback()}
    }
    
    func doneTimerCallback() {
        self.status = DownUpTimerStatus.counting_up
        stopwatch.start()
    }
}
