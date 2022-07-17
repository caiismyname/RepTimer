//
//  TimeInputKeyboardModel.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation

class TimeInputKeyboardModel: ObservableObject {
    @Published var value: TimeInterval = TimeInterval(0)
    var input = Int(0)
    
    init (value: Double = 0.0) {
        setValue(value: value)
    }
    
    func setValue(value: Double) {
        self.value = value
        self.input = Int(value)
    }
    
    func addDigit(digit: String) {
        switch digit {
        case "<":
            backspace()
        case " ":
            return
        default:
            input = (input * 10) + Int(digit)!
            calculateValue()
        }
    }
    
    func backspace() {
        input = Int(floor(Double(input) / 10))
        calculateValue()
    }
    
    func calculateValue() {
        let seconds = input % 100
        let minutes = Int(floor((Double(input) / 100))) % 100
        let hours = Int(floor((Double(input) / 10000))) % 10000
        
        value = TimeInterval(seconds + (60 * minutes) + (3600 * hours))
    }
}
