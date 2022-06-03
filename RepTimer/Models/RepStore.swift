//
//  TimerStore.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI

class RepStore: ObservableObject {
    @Published var rep: Rep = Rep()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
         .appendingPathComponent("timer.data")
    }
    
    static func load(completion: @escaping (Result<Rep, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(Rep()))
                    }
                    return
                }
                
                // Successful loading
                let loadedRep = try JSONDecoder().decode(Rep.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedRep))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(rep: Rep, completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
           do {
               let data = try JSONEncoder().encode(rep)
               let outfile = try fileURL()
               try data.write(to: outfile)
               DispatchQueue.main.async {
                   completion(.success(1))
               }
           } catch {
               DispatchQueue.main.async {
                   completion(.failure(error))
               }
           }
       }
    }
}
