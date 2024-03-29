//
//  TimerTimelineModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import UserNotifications

class TimersController: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // Timeline
    @Published var activeTimers: [SingleTimer] = []
    @Published var completedTimers: [SingleTimer] = []
    @Published var bottomDuration: TimeInterval = TimeInterval(0.0) // The TimeInteral value that denotes "bottom of the screen"
//    @Published var editTimerID: String = ""
    
    override init() {
        super.init()
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Error getting notif permissions")
                print(error)
            } else if granted {
                print("Notification permissions granted")
            }
        }

//        // Define the custom actions.
//        let timerDismissAction = UNNotificationAction(identifier: "TIMER_DISMISS_ACTION",
//              title: "Dismiss",
//              options: [])
//
//        // Define the notification type
//        let timerEndCategory =
//              UNNotificationCategory(identifier: "TIMER_END",
//              actions: [timerDismissAction],
//              intentIdentifiers: [],
//              hiddenPreviewsBodyPlaceholder: "",
//              options: .customDismissAction)
//
//        // Register the notification type.
//        center.setNotificationCategories([timerEndCategory])

//        // Set this object as the notification delegate
        center.delegate = self
//        center.getNotificationSettings(completionHandler: { settings in
//            if settings.authorizationStatus == .authorized  {
//                print("Notification permission granted")
//            }
//        })
    }
    
    // MARK: Timeline
    
    func addTimer(timeRemaining: TimeInterval, name: String, repeatAlert: Bool) {
        let newTimer = SingleTimer(timeRemaining: timeRemaining, name: name, repeatAlert: repeatAlert)
        newTimer.doneCallback = {self.cleanActiveTimersList()}
        activeTimers.append(newTimer)
        bottomDuration = max(bottomDuration, newTimer.duration)
        newTimer.start()
    }
    
    func recomputeBottomDuration() {
        if self.activeTimers.isEmpty {
            bottomDuration = 0.0
        }
        
        for timer in self.activeTimers {
            if timer.duration > bottomDuration {
                bottomDuration = timer.duration
            }
        }
    }
    
    func startSystemTimers() {
        recomputeBottomDuration()

        for timer in self.activeTimers {
            timer.startSystemTimer()
        }
    }
    
    func getTimerByNotifID(notifID: String) -> SingleTimer? {
        let allTimers = activeTimers + completedTimers
        let matchingTimers = allTimers.filter { timer in
            return (timer.notifID == notifID)
        }
        
        if matchingTimers.count == 1 {
            return matchingTimers[0]
        } else {
            return nil
        }
    }
    
//    func getEditTimer() -> SingleTimer? {
//        return getTimerByNotifID(notifID: editTimerID)
//    }
                   
    // not sure what this function is, I think it's the background handler?
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        guard let timer = getTimerByNotifID(notifID: response.notification.request.identifier) else {
            print("Timer not found")
            return
        }

        timerEnded(notifID: response.notification.request.identifier)
        timer.stopPlaying() // Stop the alert audio when notification is tapped
        timer.backgroundDoneHandler()
    }
    
    // Foreground notif handler
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
         willPresent notification: UNNotification,
         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        guard let timer = getTimerByNotifID(notifID: notification.request.identifier) else {
            return
        }
        
        timerEnded(notifID: notification.request.identifier)
        timer.foregroundDoneHandler()
    }
    
    // Moves timer from the active list to the done list
    func timerEnded(notifID: String) {
        guard let timer = getTimerByNotifID(notifID: notifID) else {
            return
        }
        
        self.activeTimers.removeAll(where: {t in t.notifID == notifID})
        if (!self.completedTimers.contains(timer)) { // This check creates idempotence
            self.completedTimers.append(timer)
        }
        self.recomputeBottomDuration()
    }
    
    // Cleans the active timer list (handles `ended` and `canceled` timers)
    func cleanActiveTimersList() {
        let endedTimers = self.activeTimers
            .filter({t in t.status == TimerStatus.ended})
            .map({t in t.notifID})
        
        for timerId in endedTimers {
            timerEnded(notifID: timerId)
        }
        
        // Remove canceled timers from the active list, nothing happens to them.
        self.activeTimers = self.activeTimers
            .filter({t in t.status != TimerStatus.canceled})
        
        recomputeBottomDuration()
    }
    
    func clearCompletedTimers() {
        self.completedTimers = []
    }
    
    // MARK: Codable
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func dataModelURL(dataFileName: String) -> URL {
        let docURL = documentsDirectory()
        return docURL.appendingPathComponent(dataFileName)
    }

    func saveTimers() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(["activeTimers": activeTimers, "completedTimers": completedTimers]) {
            do {
                try encoded.write(to: dataModelURL(dataFileName: "timers"))
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
    
    func loadTimers(completion: @escaping (Result<[String: [SingleTimer]], Error>) -> Void) {

// Uncomment to override saved values
//        DispatchQueue.main.async {
//            print("Loading override timers")
//            completion(.success(["activeTimers": [], "completedTimers": []]))
//        }

        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = self.dataModelURL(dataFileName: "timers")
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(["activeTimers": [], "completedTimers": []]))
                    }
                    return
                }

                // Successful loading
                let results = try JSONDecoder().decode([String: [SingleTimer]].self, from: file.availableData)
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

