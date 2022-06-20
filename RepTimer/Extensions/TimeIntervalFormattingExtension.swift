//
//  TimeIntervalFormattingExtension.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.c
//

import Foundation

extension TimeInterval {
    var hours: Int {
        return Int(floor(self / 3600))
    }
    
    var minutes: Int {
        return Int(floor(Double((Int(self) % 3600)) / 60))
    }
    
    var seconds: Int {
        return Int(self) % 60
    }
    
    var miliseconds: Int {
        return Int((self*100).truncatingRemainder(dividingBy: 100))
    }
    
    var formattedTimeTwoMilli: String {
        let displayHours = self.hours == 0 ? "" : self.hours.withLeadingZero + ":"
        return String(
            displayHours + self.minutes.withLeadingZero + ":" + self.seconds.withLeadingZero + "." + self.miliseconds.withLeadingZero
        )
    }
    
    var formattedTimeNoMilli: String {
        let displayHours = self.hours == 0 ? "" : self.hours.withLeadingZero + ":"
        return String(
            displayHours + self.minutes.withLeadingZero + ":" + self.seconds.withLeadingZero
        )
    }
}

extension Int {
    var withLeadingZero: String {
        return ((self < 10 ? "0" : "") + String(self))
    }
}
