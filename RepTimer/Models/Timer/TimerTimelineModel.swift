//
//  TimerTimelineModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
class TimerTimelineController: ObservableObject {
    @Published var timers: [SingleTimer] = []
    @Published var bottomDuration: TimeInterval = TimeInterval(0) // The TimeInteral value that denotes "bottom of the screen"
    
    init() {
        
    }
    
    func addTimer(timeRemaining: TimeInterval) {
        timers.append(SingleTimer(timeRemaining: timeRemaining))
        bottomDuration = max(bottomDuration, timeRemaining)
    }
    
    func updateButtomDuration() {
        for timer in timers {
            bottomDuration = max(bottomDuration, timer.timeRemaining)
        }
    }
    
}
