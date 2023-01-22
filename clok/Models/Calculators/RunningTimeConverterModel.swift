//
//  RunningTimeConverterModel.swift
//  RepTimer
//
//  Created by David Cai on 1/21/23.
//

import Foundation

enum RunningDistances: Codable {
    case faoo
}

class RunningDistance: ObservableObject {
    let name: String
    let distanceInMeters: Double
    @Published var time: TimeInterval
    @Published var selected: Bool
    
    init(name: String, distanceInMeters: Double, time: TimeInterval, selected: Bool = false) {
        self.name = name
        self.distanceInMeters = distanceInMeters
        self.time = time
        self.selected = selected
    }
    
    func recomputeTimeWithBasis(basis: RunningDistance) {
        let basisSecondPerMeter = basis.time / basis.distanceInMeters
        let newTime = basisSecondPerMeter * self.distanceInMeters
        self.time = newTime
    }
}

class RunningTimeConverterModel: ObservableObject {
    @Published var basisDistance = RunningDistance(name: "Mile", distanceInMeters: 1609.34, time: TimeInterval(480))
    
    var keyboardModel = TimeInputKeyboardModel(value: 0)
    let distances = [
        RunningDistance(name: "100m", distanceInMeters: 100.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "200m", distanceInMeters: 200.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "300m", distanceInMeters: 300.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "400m", distanceInMeters: 400.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "600m", distanceInMeters: 600.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "800m", distanceInMeters: 800.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1000m", distanceInMeters: 1000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1200m", distanceInMeters: 1200.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "1500m", distanceInMeters: 1500.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1600m", distanceInMeters: 1600.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "Mile", distanceInMeters: 1609.34, time: TimeInterval(0), selected: true),
        RunningDistance(name: "5km", distanceInMeters: 5000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "10km", distanceInMeters: 10000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "15km", distanceInMeters: 15000.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "5 Mile", distanceInMeters: 8046.7, time: TimeInterval(0), selected: false),
        RunningDistance(name: "10 Mile", distanceInMeters: 16093.4, time: TimeInterval(0), selected: false),
        RunningDistance(name: "Half", distanceInMeters: 21097.5, time: TimeInterval(0), selected: true),
        RunningDistance(name: "Marathon", distanceInMeters: 42195.0, time: TimeInterval(0), selected: true)
    ]
    
    init() {
        recomputeAll()
    }
    
    func recomputeAll() {
        distances.forEach { distance in
            distance.recomputeTimeWithBasis(basis: basisDistance)
        }
    }
    
    func changeBasis(newBasis: RunningDistance) {
        self.basisDistance = newBasis
    }
    
    func changeBasisTime(newTime: TimeInterval) {
        self.basisDistance.time = newTime
    }
}
