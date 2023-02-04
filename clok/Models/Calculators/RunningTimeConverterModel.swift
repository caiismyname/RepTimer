//
//  RunningTimeConverterModel.swift
//  RepTimer
//
//  Created by David Cai on 1/21/23.
//

import Foundation

class RunningDistance: ObservableObject, Codable {
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
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case name
        case distanceInMeters
        case time
        case selected
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distanceInMeters, forKey: .distanceInMeters)
        try container.encode(time, forKey: .time)
        try container.encode(selected, forKey: .selected)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        name = try values.decode(String.self, forKey: .name)
        distanceInMeters = try values.decode(Double.self, forKey: .distanceInMeters)
        time = try values.decode(TimeInterval.self, forKey: .time)
        selected = try values.decode(Bool.self, forKey: .selected)
    }
}

class RunningTimeConverterModel: ObservableObject {
    var keyboardModel = TimeInputKeyboardModel(value: 0)
    @Published var basisDistance = RunningDistance(name: "Mile", distanceInMeters: 1609.34, time: TimeInterval(480))
    var distances = [
        RunningDistance(name: "60m", distanceInMeters: 60.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "100m", distanceInMeters: 100.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "200m", distanceInMeters: 200.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "300m", distanceInMeters: 300.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "400m", distanceInMeters: 400.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "600m", distanceInMeters: 600.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "800m", distanceInMeters: 800.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1km (1000m)", distanceInMeters: 1000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1200m", distanceInMeters: 1200.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "1500m", distanceInMeters: 1500.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "1600m", distanceInMeters: 1600.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "3200m", distanceInMeters: 3200.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "3km", distanceInMeters: 3000.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "5km", distanceInMeters: 5000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "6km", distanceInMeters: 6000.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "8km", distanceInMeters: 8000.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "10km", distanceInMeters: 10000.0, time: TimeInterval(0), selected: true),
        RunningDistance(name: "15km", distanceInMeters: 15000.0, time: TimeInterval(0), selected: false),
        RunningDistance(name: "Mile", distanceInMeters: 1609.34, time: TimeInterval(0), selected: true),
        RunningDistance(name: "2 Mile", distanceInMeters: 3218.68, time: TimeInterval(0), selected: false),
        RunningDistance(name: "5 Mile", distanceInMeters: 8046.7, time: TimeInterval(0), selected: false),
        RunningDistance(name: "10 Mile", distanceInMeters: 16093.4, time: TimeInterval(0), selected: false),
        RunningDistance(name: "Half", distanceInMeters: 21097.5, time: TimeInterval(0), selected: true),
        RunningDistance(name: "Marathon", distanceInMeters: 42195.0, time: TimeInterval(0), selected: true)
    ]
    
    init() {
        loadRunningTimeConverter()
        recomputeAll()
    }
    
    func recomputeAll() {
        distances.forEach { distance in
            if distance.distanceInMeters != basisDistance.distanceInMeters { //
                distance.recomputeTimeWithBasis(basis: basisDistance)
            }
        }
    }
    
    func changeBasis(newBasis: RunningDistance) {
        self.basisDistance = newBasis
        saveRunningTimeConverter()
    }
    
    func changeBasisTime(newTime: TimeInterval) {
        self.basisDistance.time = newTime
        saveRunningTimeConverter()
    }
    
    // MARK: — Saving
    
    func saveRunningTimeConverter() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(["basisDistance": [basisDistance], "distances": distances]) {
            do {
                try encoded.write(to: CodableFileURLGenerator(dataFileName: "runningTimeConverter"))
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
    
    private func loadRunningTimeConverter() {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = CodableFileURLGenerator(dataFileName: "runningTimeConverter")
                // If loading fails, do nothing since we have defaults
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    return
                }
                
                // Successful loading
                let results = try JSONDecoder().decode([String: [RunningDistance]].self, from: file.availableData)
                self.basisDistance = results["basisDistance"]![0] // Stored in a list for homogenity of types
                self.distances = results["distances"]!
                
            } catch {
                return
            }
        }
    }
}
