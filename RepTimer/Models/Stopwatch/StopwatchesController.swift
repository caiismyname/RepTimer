//
//  StopwatchesController.swift
//  RepTimer
//
//  Created by David Cai on 6/26/22.
//

import Foundation

class StopwatchesController: Codable, ObservableObject {
    @Published var stopwatches: [SingleStopWatch]
    private let dataFileName = "Stopwatches" // The archived file name, name saved to Documents folder.
    
    init() {
        self.stopwatches = [SingleStopWatch()]
    }
    
    func startAllTimers() {
        for stopwatch in stopwatches {
            stopwatch.startTimer()
        }
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case stopwatches
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(stopwatches, forKey: .stopwatches)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        stopwatches = try values.decode([SingleStopWatch].self, forKey: .stopwatches)
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
        if let encoded = try? encoder.encode(stopwatches) {
            do {
                // Save the 'Stopwatches' data file to the Documents directory.
                try encoded.write(to: dataModelURL())
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
    
    func loadStopwatches(completion: @escaping (Result<[SingleStopWatch], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = self.dataModelURL()
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([SingleStopWatch()]))
                    }
                    return
                }

                // Successful loading
                let loadedStopwatches = try JSONDecoder().decode([SingleStopWatch].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedStopwatches))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
