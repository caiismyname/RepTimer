//
//  PeriodModel.swift
//  RepTimer
//
//  Created by David Cai on 6/5/22.
//

import Foundation
import SwiftUI

protocol Period {
    var startTime: Date {get set}
    var duration: TimeInterval {get set}
    var isActive: Bool {get set}
}

extension Period {
    var displayFormatted: String {
        let displayHours = duration.hours == 0 ? "" : duration.hours.withLeadingZero + ":"
        return String(
            displayHours + duration.minutes.withLeadingZero + ":" + duration.seconds.withLeadingZero
        )
    }
}
