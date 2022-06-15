//
//  SingleTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation

class SingleTimer {
    @Published var status: TimerStatus = TimerStatus.inactive
    @Published var timeRemaining: TimeInterval
    let originalTime: TimeInterval
    let id: UUID = UUID()
    
    init(timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.originalTime = timeRemaining
    }
}

extension SingleTimer: Hashable {
    static func == (lhs: SingleTimer, rhs: SingleTimer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TimerStatus {
    case inactive
    case active
    case ended
}
