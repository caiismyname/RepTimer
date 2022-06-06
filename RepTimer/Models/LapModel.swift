//
//  LapModel.swift
//  RepTimer
//
//  Created by David Cai on 6/5/22.
//

import Foundation
import SwiftUI

class Lap: Period {
    var startTime: Date
    var duration: TimeInterval
    var isActive: Bool
    
    init(startTime: Date) {
        self.startTime = startTime
        self.duration = TimeInterval(0)
        self.isActive = true
    }
}
