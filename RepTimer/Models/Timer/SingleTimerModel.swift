//
//  SingleTimerModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import UserNotifications

class SingleTimer: ObservableObject {
    @Published var status: TimerStatus = TimerStatus.inactive
    @Published var timeRemaining: TimeInterval
    let duration: TimeInterval
    var timer: Timer = Timer()
    var lastPollTime = Date()
    let id: UUID = UUID()
    var name: String
    
    init(timeRemaining: TimeInterval, name: String) {
        self.timeRemaining = timeRemaining
        self.duration = timeRemaining
        self.name = name
        
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.001),
            target: self,
            selector: (#selector(update)),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer, forMode: .common)
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
            }
        }
        
        // Temp
        start()
    }
    
    @objc func update() {
        // Only update if the period is active
        guard status == TimerStatus.active else {
            return
        }
        
        guard timeRemaining > 0 else {
            status = TimerStatus.ended
            timeRemaining = 0.0
            return
        }
        
        // Recalculate `timeRemaining`
        let now = Date()
        let delta = now.timeIntervalSince(lastPollTime)
        timeRemaining -= delta
        
        // Reset lastPollTime
        lastPollTime = now
    }
    
    func setNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.duration, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = self.name
        content.body = "Your timer is done."
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // TODO handle error
           }
        }
    }
    
    func start() {
        lastPollTime = Date()
        setNotification()
        status = TimerStatus.active
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

enum TimerStatus {
    case inactive
    case active
    case ended
}
