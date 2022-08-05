//
//  SingleTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import UserNotifications
import AVFoundation

class SingleTimer: ObservableObject, Codable {
    @Published var status: TimerStatus = TimerStatus.inactive
    @Published var timeRemaining: TimeInterval
    let duration: TimeInterval
    var startTime = Date()
    var timer: Timer = Timer()
    var scheduledEndTime: Date {
        startTime + duration
    }
    var lastPollTime = Date()
    var id: UUID = UUID()
    var name: String
    var avplayer: AVAudioPlayer? // This needs to be an instance var otherwise the player disappears before the audio finishes playing
    var doneCallback = {}
    var notifID: String = ""
    
    init(timeRemaining: TimeInterval, name: String) {
        self.timeRemaining = timeRemaining
        self.duration = timeRemaining
        self.name = name
        
        // Temp for ease of building
//        start()
    }
    
    @objc func update() throws {
        // Only update if the period is active
        guard status == TimerStatus.active else {
            return
        }
        
        // Recalculate `timeRemaining`
        let now = Date()
        let delta = now.timeIntervalSince(lastPollTime)
        timeRemaining -= delta
        
        // Timer is done
        guard timeRemaining > 0.05 else {
            // TODO it seems problematic that I handle done both here and in the notif handler. This is probls the right place.
            end()
            self.doneCallback()
            return
        }
        
        // Reset lastPollTime
        lastPollTime = now
    }
    
    func setNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.duration, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = self.name
        content.body = "Your\(self.name == "" ? " " : self.name)timer (\(self.duration.formattedTimeNoMilliNoLeadingZero)) is done."
        content.sound = UNNotificationSound.default
//        content.userInfo = ["timerId": self.id]
//        content.categoryIdentifier = "TIMER_END"
        
        // Create the request
        self.notifID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notifID, content: content, trigger: trigger)

        // Schedule the request with the system.
        UNUserNotificationCenter.current().add(request) { (error) in
           if error != nil {
               print("Error scheduling notif: \(String(describing: error))")
           } else {
               print("Notification \(self.notifID) scheduled")
           }
        }
        
        // Schedule the sound
        do {
            try scheduleEndSound()
        } catch {
            print("Error scheduling audio")
        }
    }
    
    func foregroundDoneHandler() {
        end()
        self.doneCallback()
    }
    
    func backgroundDoneHandler() {
        end()
        self.doneCallback()
    }
    
    func scheduleEndSound() throws {
        do {
            guard let soundFileURL = Bundle.main.path(forResource: "done", ofType: "caf") else {
                print("no url")
                return
            }
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            self.avplayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFileURL))
            self.avplayer!.play(atTime: self.avplayer!.deviceCurrentTime + self.duration)
        } catch {
            print("audio player setup error")
            self.avplayer = nil
        }
    }
    
    func start() {
        let now = Date()
        lastPollTime = now
        startTime = now
        status = TimerStatus.active
        
        setNotification()
        startSystemTimer()
    }
    
    func startSystemTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.02),
            target: self,
            selector: (#selector(update)),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer, forMode: .common)
    }
    
    // Handles stopping the timer before it's done
    func stop() {
        status = TimerStatus.inactive
        // Remove notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifID])
        // Cancel the audio playback
        self.avplayer!.stop()
        // Stop the cron
        self.timer.invalidate()
    }
    
    // Handles cleaning up the timer after it's done
    func end() {
        status = TimerStatus.ended
        timeRemaining = 0.0
        self.timer.invalidate()
    }
    
    // MARK: — Codable
    private enum CoderKeys: String, CodingKey {
        case status
        case timeRemaining
        case startTime
        case duration
        case lastPollTime
        case id
        case name
        case notifID
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(timeRemaining, forKey: .timeRemaining)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(lastPollTime, forKey: .lastPollTime)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(notifID, forKey: .notifID)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        status = try values.decode(TimerStatus.self, forKey: .status)
        timeRemaining = try values.decode(TimeInterval.self, forKey: .timeRemaining)
        startTime = try values.decode(Date.self, forKey: .startTime)
        duration = try values.decode(TimeInterval.self, forKey: .duration)
        lastPollTime = try values.decode(Date.self, forKey: .lastPollTime)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        notifID = try values.decode(String.self, forKey: .notifID)
        
        if status != TimerStatus.inactive {
            startSystemTimer()
        }
        
        // Set up audio player
        do {
            guard let soundFileURL = Bundle.main.path(forResource: "done", ofType: "caf") else {
                print("no url")
                return
            }
            self.avplayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFileURL))
        } catch {
            print("audio player setup error")
            
            self.avplayer = nil
        }
    }
}

extension SingleTimer: Hashable {
    static func == (lhs: SingleTimer, rhs: SingleTimer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TimerStatus: Codable {
    case inactive
    case active
    case ended
}
