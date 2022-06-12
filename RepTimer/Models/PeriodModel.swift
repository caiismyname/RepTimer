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
        let displayHours = duration.hours == 0 ? "" : duration.hours.withLeadingZero + ":"
        return String(
            displayHours + duration.minutes.withLeadingZero + ":" + duration.seconds.withLeadingZero + "." + duration.miliseconds.withLeadingZero
        )
    }
}

enum PeriodStatus {
    case inactive
    case active
    case paused
}
