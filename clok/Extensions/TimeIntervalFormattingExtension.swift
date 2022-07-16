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
    
    var formattedTimeTwoMilliLeadingZero: String {
        let displayHours = self.hours == 0 ? "" : self.hours.withLeadingZero + ":"
        return String(
            displayHours + self.minutes.withLeadingZero + ":" + self.seconds.withLeadingZero + "." + self.miliseconds.withLeadingZero
        )
    }
    
    var formattedTimeOneMilliLeadingZero: String {
        let displayHours = self.hours == 0 ? "" : self.hours.withLeadingZero + ":"
        return String(
            displayHours + self.minutes.withLeadingZero + ":" + self.seconds.withLeadingZero + "." + String(self.miliseconds / 10)
        )
    }
    
    var formattedTimeNoMilliLeadingZero: String {
        let displayHours = self.hours == 0 ? "" : self.hours.withLeadingZero + ":"
        return String(
            displayHours + self.minutes.withLeadingZero + ":" + self.seconds.withLeadingZero
        )
    }
    
    var formattedTimeNoMilliNoLeadingZero: String {
        let displayHours = self.hours == 0 ? "" : String(self.hours) + ":"
        return displayHours + String(self.minutes) + ":" + self.seconds.withLeadingZero
    }
    
    var formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond: String {
        let displayHours = self.hours == 0 ? "" : String(self.hours) + ":"
        return displayHours +
        String(self.seconds == 59 ? self.minutes + 1 : self.minutes)
        + ":" +
        (self.miliseconds == 0 ? self.seconds :
            self.seconds == 59 ? 0 : self.seconds + 1).withLeadingZero
    }
}

extension Int {
    var withLeadingZero: String {
        return ((self < 10 ? "0" : "") + String(self))
    }
}
