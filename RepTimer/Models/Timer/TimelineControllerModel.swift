//
//  TimerTimelineModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
class TimelineController: ObservableObject {
    @Published var timers: [SingleTimer] = []
    @Published var bottomDuration: TimeInterval = TimeInterval(0) // The TimeInteral value that denotes "bottom of the screen"
    
    init() {
        
    }
    
    func addTimer(timeRemaining: TimeInterval, name: String) {
        let newTimer = SingleTimer(timeRemaining: timeRemaining, name: name)
        timers.append(newTimer)
        bottomDuration = max(bottomDuration, newTimer.duration)
    }
    
//    func updateButtomDuration() {
//        for timer in timers {
//            bottomDuration = max(bottomDuration, timer.timeRemaining)
//        }
//    }
}
