//
//  TimerStore.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI

class StorageManager: ObservableObject {
    
    static private let dataFileName = "Stopwatches" // The archived file name, name saved to Documents folder.
    
//    private static func fileURL() throws -> URL {
//        try FileManager.default.url(for: .documentDirectory,
//                                    in: .userDomainMask,
//                                    appropriateFor: nil,
//                                    create: false)
//         .appendingPathComponent("timer.data")
//    }
    
    static private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static private func dataModelURL() -> URL {
        let docURL = documentsDirectory()
        return docURL.appendingPathComponent(dataFileName)
    }
    
    static func loadStopwatches(completion: @escaping (Result<StopwatchesController, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = dataModelURL()
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(StopwatchesController()))
                    }
                    return
                }

                // Successful loading
                let loadedStopwatchesController = try JSONDecoder().decode(StopwatchesController.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedStopwatchesController))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(rep: SingleStopWatch, completion: @escaping (Result<Int, Error>) -> Void) {
//        DispatchQueue.global(qos: .background).async {
//           do {
//               let data = try JSONEncoder().encode(rep)
//               let outfile = try fileURL()
//               try data.write(to: outfile)
//               DispatchQueue.main.async {
//                   completion(.success(1))
//               }
//           } catch {
//               DispatchQueue.main.async {
//                   completion(.failure(error))
//               }
//           }
//       }
    }
}
