//
//  StopwatchesController.swift
//  RepTimer
//
//  Created by David Cai on 6/26/22.
//

import Foundation

class StopwatchesController: Codable, ObservableObject {
    @Published var stopwatches: [SingleStopWatch]
    var pastStopwatches: [SingleStopWatch]
    private let dataFileName = "Stopwatches" // The archived file name, name saved to Documents folder.
    
    init() {
        self.stopwatches = [SingleStopWatch()] // no resetCallback on this one...
        self.pastStopwatches = []
    }
    
    func resetCallback() {
        for s in stopwatches {
            if s.status == PeriodStatus.ended {
                pastStopwatches.append(s)
            }
        }
        
        pastStopwatchMaintenance()
       
        stopwatches = stopwatches.map {
            if $0.status != PeriodStatus.ended {
                return $0
            } else {
                let newStopwatch = SingleStopWatch()
                newStopwatch.resetCallback = {self.resetCallback()}
                return newStopwatch
            }
        }
    }
    
    func newStopwatch() {
        let s = SingleStopWatch()
        s.resetCallback = {self.resetCallback()}
        self.stopwatches.append(s)
    }
    
    func startAllTimers() {
        for stopwatch in stopwatches {
            stopwatch.startTimer()
        }
    }
    
    func pastStopwatchMaintenance() {
        pastStopwatches.sort() { lhs, rhs in
            return lhs.createDate > rhs.createDate
        }
        
        if pastStopwatches.count > 20 {
            pastStopwatches = pastStopwatches.dropLast(pastStopwatches.count - 20)
        }
    }
    
    func setAllResetCallbacks() {
        for stopwatch in stopwatches {
            stopwatch.resetCallback = {self.resetCallback()}
        }
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case stopwatches
        case pastStopwatches
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(stopwatches, forKey: .stopwatches)
        try container.encode(pastStopwatches, forKey: .pastStopwatches)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        stopwatches = try values.decode([SingleStopWatch].self, forKey: .stopwatches)
        pastStopwatches = try values.decode([SingleStopWatch].self, forKey: .pastStopwatches)
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func dataModelURL() -> URL {
        let docURL = documentsDirectory()
        return docURL.appendingPathComponent(dataFileName)
    }

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(["stopwatches": stopwatches, "pastStopwatches": pastStopwatches]) {
            do {
                // Save the 'Stopwatches' data file to the Documents directory.
                try encoded.write(to: dataModelURL())
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
    
    func loadStopwatches(completion: @escaping (Result<[String: [SingleStopWatch]], Error>) -> Void) {
        // MARK: Uncomment this block to reset the saved on-disk stopwatches
//        DispatchQueue.main.async {
//            let firstStopwatch = SingleStopWatch()
//            firstStopwatch.resetCallback = {self.resetCallback()}
//            completion(.success(["stopwatches": [firstStopwatch], "pastStopwatches": []]))
//        }


        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = self.dataModelURL()
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        let firstStopwatch = SingleStopWatch()
                        firstStopwatch.resetCallback = {self.resetCallback()}
                        completion(.success(["stopwatches": [firstStopwatch], "pastStopwatches": []]))
                    }
                    return
                }

                // Successful loading
                let results = try JSONDecoder().decode([String: [SingleStopWatch]].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
