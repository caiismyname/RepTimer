//
//  PeriodModel.swift
//  RepTimer
//
//  Created by David Cai on 6/5/22.
//

import Foundation
import SwiftUI

protocol Period {
    var lastPollTime: Date {get set}
    var duration: TimeInterval {get set}
    var status: PeriodStatus {get set}
    
    func update()
    func start()
    func pause()
    func resume()
}

extension Period {
    var displayFormatted: String {
        return duration.formattedTimeTwoMilliLeadingZero
    }
//
//    func formatTime(time: TimeInterval) -> String {
//        let displayHours = time.hours == 0 ? "" : time.hours.withLeadingZero + ":"
//        return String(
//            displayHours + time.minutes.withLeadingZero + ":" + time.seconds.withLeadingZero + "." + time.miliseconds.withLeadingZero
//        )
//    }
}

enum PeriodStatus {
    case inactive
    case active
    case paused
}
