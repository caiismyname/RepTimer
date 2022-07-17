//
//  DateExtensions.swift
//  RepTimer
//
//  Created by David Cai on 7/17/22.
//

import Foundation

extension Date {
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE M/dd"
        
        return formatter.string(from: self)
    }
    
    var displayTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        
        return formatter.string(from: self)
    }
    
    func isSameDayAs(comp: Date) -> Bool {
        let selfDay = Calendar.current.dateComponents([.day], from: self)
        let compDay = Calendar.current.dateComponents([.day], from: comp)
        
        return selfDay == compDay
    }
}
