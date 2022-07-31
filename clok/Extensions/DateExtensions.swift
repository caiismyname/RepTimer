//
//  DateExtensions.swift
//  RepTimer
//
//  Created by David Cai on 7/17/22.
//

import Foundation

extension Date {
    var displayDayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE M/dd"
        
        return formatter.string(from: self)
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "M/dd"
        
        return formatter.string(from: self)
    }
    
    var displayTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mma"
        
        return formatter.string(from: self).lowercased()
    }
    
    func isSameDayAs(comp: Date) -> Bool {
        let selfDay = Calendar.current.dateComponents([.day], from: self)
        let compDay = Calendar.current.dateComponents([.day], from: comp)
        
        return selfDay == compDay
    }
}
