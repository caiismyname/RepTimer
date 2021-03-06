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
    func start(startTime: Date)
    func pause()
    func resume()
}

extension Period {
    var displayFormatted: String {
        // Default format, but you can specify your own using the extension
        return duration.formattedTimeTwoMilliLeadingZero
    }
}

enum PeriodStatus: Codable {
    case inactive // before it starts
    case active
    case paused
    case ended // after it's been reset
}
