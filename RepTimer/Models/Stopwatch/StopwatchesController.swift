//
//  StopwatchesController.swift
//  RepTimer
//
//  Created by David Cai on 6/26/22.
//

import Foundation

class StopwatchesController: Codable, ObservableObject {
    @Published var stopwatches: [SingleStopWatch]
    
    init() {
        self.stopwatches = [SingleStopWatch()]
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
}
