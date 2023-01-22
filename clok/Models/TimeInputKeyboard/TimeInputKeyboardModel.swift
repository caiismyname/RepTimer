//
//  TimeInputKeyboardModel.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation

class TimeInputKeyboardModel: ObservableObject {
    @Published var value: TimeInterval = TimeInterval(0) // Converting display value into a sensible number of seconds
    @Published var input = TimeInterval(0) // Display value, matches what's typed
    
    init (value: Double = 0.0) {
        setValue(value: value)
    }
    
    // Externally set the value / input.
    func setValue(value: Double) {
        self.value = value
        self.input = Double(value.formattedTimeNoMilliLeadingZero.filter({ char in char != ":"}))!
    }
    
    func addDigit(digit: String) {
        switch digit {
        case "<":
            backspace()
        case " ":
            return
        default:
            input = (input * 10) + Double(digit)!
            calculateValue()
        }
    }
    
    func backspace() {
        input = floor(input / 10)
        calculateValue()
    }
    
    func calculateValue() {
        let seconds = Int(input.truncatingRemainder(dividingBy: 100))
        let minutes = Int(floor((Double(input) / 100))) % 100
        let hours = Int(floor((Double(input) / 10000))) % 10000
        
        value = TimeInterval(seconds + (60 * minutes) + (3600 * hours))
    }
}
