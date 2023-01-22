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
        return displayHours + String(self.minutes.withLeadingZero) + ":" + self.seconds.withLeadingZero
    }
    
    // Examples:
    // 1:23:45
    // 1:03:45
    // 3:45, not 03:45
    // 0:45, not :45
    var formattedTimeNoMilliNoMinutesLeadingZero: String {
        let displayHours = self.hours == 0 ? "" : String(self.hours) + ":"
        let displayMinutes = (self.hours == 0 ? String(self.minutes) : self.minutes.withLeadingZero) + ":"
        return displayHours + displayMinutes + self.seconds.withLeadingZero
    }
    
    var formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond: String {
        let displayHours = self.hours == 0 ? "" : String(self.hours) + ":"
        return displayHours +
        String(self.seconds == 59 ? self.minutes + 1 : self.minutes)
        + ":" +
        (self.miliseconds == 0 ? self.seconds :
            self.seconds == 59 ? 0 : self.seconds + 1).withLeadingZero
    }
    
    //Returns the literal number inputted, for TimeInputKeyboard
    var literalInputString: String {
        if self == 0.0 {
            return ("00:00")
        }
        
        let inputString = String(Int(self))
        var displayValue = ""
        
        var colonCount = 0
        for char in inputString.reversed() {
            displayValue = String(char) + displayValue
            colonCount += 1
            if colonCount == 2 {
                displayValue = ":" + displayValue
                colonCount = 0
            }
        }

        // Keyboard expects at least 5 chars for splitting ("xx:xx")
        // If the value itself is less than 4 digits, we need to patch it up with leading zeros
        while 5 - displayValue.count > 0 {
            if displayValue.count == 2 {
                displayValue = ":" + displayValue
            } else {
                displayValue = "0" + displayValue
            }
        }
            
        return displayValue
    }
}

extension Int {
    var withLeadingZero: String {
        return ((self < 10 ? "0" : "") + String(self))
    }
}
