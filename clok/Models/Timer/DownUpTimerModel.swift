//
//  DownUpTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import UserNotifications
import AVFoundation
import WidgetKit

enum DownUpTimerStatus: Codable {
    case inactive
    case active
    case paused
}

enum DownUpTimerDirection: Codable {
    case counting_down
    case counting_up
}

class DownUpTimer: ObservableObject, Codable {
    @Published var timer = SingleTimer(timeRemaining: 100, name: "", repeatAlert: false) // Placeholder timer, will be replaced when `reset()` is called
    @Published var stopwatch = SingleStopWatch()
    @Published var status = DownUpTimerStatus.inactive
    @Published var startingDirection = DownUpTimerDirection.counting_down
    @Published var currentDirection = DownUpTimerDirection.counting_down
    @Published var timerDuration = 0.0 // How long the timer should be set for each rep
    @Published var keyboard = TimeInputKeyboardModel(value: 0.0)
    @Published var cycleCount = 0
    @Published var totalDurationStopwatch = SingleStopWatch()
    
    init() {
        // Need a blank init b/c the Codable init overrides
        load()
    }
    
    func nextPhase() {
        guard self.timerDuration != 0.0 else {
            self.status = .inactive
            return
        }
        
        // On start
        if cycleCount == 0 {
            self.status = .active
            self.currentDirection = self.startingDirection == .counting_up ? .counting_down : .counting_up // Initialize to opposite so upcoming code switches the state to the correct one
            if self.totalDurationStopwatch.status != .active {
                self.totalDurationStopwatch.start()
            }
        }
        
        // Resume from pause
        if status == .paused {
            if currentDirection == .counting_up {
                self.stopwatch.resume()
            } else if currentDirection == .counting_down {
                self.timer.start()
            }
            
            self.totalDurationStopwatch.resume()
            self.status = .active
        } else if currentDirection == .counting_up { // Currently counting up, switch to down
            self.stopwatch.pause()
            
            initTimer()
            self.timer.start()
            self.currentDirection = .counting_down
            
            checkAndIncrementTotalCycleCount()
        } else if currentDirection == .counting_down { // Currently counting down, switch to up
            self.timer.stop() // This removes the sound/notif from the current timer, which is only necessary if we're stopping it early
            doneTimerCallback() // This function will increment the totalCycleCount for us
        }
        
        save()
    }
    
    private func checkAndIncrementTotalCycleCount() {
        // Maintain session counter (only count when we cycle around)
        if self.currentDirection == self.startingDirection {
            self.cycleCount = self.cycleCount + 1
        }
    }
    
    func pause() {
        if self.currentDirection == .counting_up {
            self.stopwatch.pause()
        } else if self.currentDirection == .counting_down {
            self.timer.pause()
        }
        
        self.totalDurationStopwatch.pause()
        self.status = .paused
        save()
    }
    
    func reset() {
        self.status = .inactive
        self.timer.stop()
        self.stopwatch = SingleStopWatch()  // Stopwatch's own reset func is mostly just a callback handler. Easier to just replace it here
        self.cycleCount = 0
        self.totalDurationStopwatch = SingleStopWatch()
        
        save()
    }
    
    func initTimer() {
        self.timer = SingleTimer(timeRemaining: self.timerDuration, name: "", repeatAlert: false)
        setTimerCallback()
    }
    
    func setTimerCallback() {
        self.timer.doneCallback = {self.doneTimerCallback()}
    }
    
    func doneTimerCallback() {
        self.stopwatch = SingleStopWatch() // "reset" the stopwatch
        self.stopwatch.start()
        self.currentDirection = .counting_up
        
        checkAndIncrementTotalCycleCount()
    }
    
    func startSystemTimers() {
        keyboard.setValue(value: timerDuration)
        
        guard self.status != DownUpTimerStatus.inactive else {
            return
        }
        
        if currentDirection == .counting_up {
            self.stopwatch.startTimer() 
        } else {
            // If we passed the end of the timer while in background
            if Date() > timer.scheduledEndTime {
                self.stopwatch = SingleStopWatch()
                self.stopwatch.start(startTime: timer.scheduledEndTime)
                self.currentDirection = .counting_up
                checkAndIncrementTotalCycleCount()
            } else {
                setTimerCallback()
                self.timer.startSystemTimer()
            }
        }
        
        self.totalDurationStopwatch.start()
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case timer
        case stopwatch
        case status
        case timerDuration
        case startingDirection
        case currentDirection
        case cycleCount
        case totalDurationStopwatch
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(timer, forKey: .timer)
        try container.encode(stopwatch, forKey: .stopwatch)
        try container.encode(status, forKey: .status)
        try container.encode(timerDuration, forKey: .timerDuration)
        try container.encode(startingDirection, forKey: .startingDirection)
        try container.encode(currentDirection, forKey: .currentDirection)
        try container.encode(cycleCount, forKey: .cycleCount)
        try container.encode(totalDurationStopwatch, forKey: .totalDurationStopwatch)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        timer = try values.decode(SingleTimer.self, forKey: .timer)
        stopwatch = try values.decode(SingleStopWatch.self, forKey: .stopwatch)
        status = try values.decode(DownUpTimerStatus.self, forKey: .status)
        timerDuration = try values.decode(TimeInterval.self, forKey: .timerDuration)
        startingDirection = try values.decode(DownUpTimerDirection.self, forKey: .startingDirection)
        currentDirection = try values.decode(DownUpTimerDirection.self, forKey: .currentDirection)
        cycleCount = try values.decode(Int.self, forKey: .cycleCount)
        totalDurationStopwatch = try values.decode(SingleStopWatch.self, forKey: .totalDurationStopwatch)
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(["downupTimer": self]) {
            do {
                // Save the 'downupTimer' data file to the Documents directory.
                try encoded.write(to: CodableFileURLGenerator(dataFileName: "downupTimer"))
                print("Saved DownUp Timer")
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        } else {
            print("Error saving DownUp Timer")
        }
    }
    
    func load() {
        if let loaded = DownUpTimer.loadFromFile() {
            // Replace self with all the properties of the loaded version
            self.timer = loaded.timer
            self.stopwatch = loaded.stopwatch
            self.status = loaded.status
            self.timerDuration = loaded.timerDuration
            self.startingDirection = loaded.startingDirection
            self.currentDirection = loaded.currentDirection
            self.cycleCount = loaded.cycleCount
            self.totalDurationStopwatch = loaded.totalDurationStopwatch
            
            self.startSystemTimers()
        }
    }
    
    static func loadFromFile() -> DownUpTimer? {
        do {
            print("Loading DownUp Timer from file")
            let fileURL = CodableFileURLGenerator(dataFileName: "downupTimer")
            // If loading fails, do nothing since we have defaults
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                print("Error reading DownUp Timer save file")
                return nil
            }
            
            // Successful file reading. Decode the info into the object
            let result = try JSONDecoder().decode([String: DownUpTimer].self, from: file.availableData)
            return result["downupTimer"]
        } catch {
            print("Error loading DownUp Timer")
            print("    \(error)")
            return nil
        }
    }
}
