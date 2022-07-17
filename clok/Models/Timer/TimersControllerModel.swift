//
//  TimerTimelineModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import UserNotifications

class TimersController: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let dataFileName = "timers" // The archived file name, name saved to Documents folder.
    // Timeline
    @Published var timers: [SingleTimer] = []
    @Published var bottomDuration: TimeInterval = TimeInterval(0.0) // The TimeInteral value that denotes "bottom of the screen"
    // DownUp
    @Published var downupTimer: DownUpTimer = DownUpTimer()
    
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
    
    func addTimer(timeRemaining: TimeInterval, name: String) {
        let newTimer = SingleTimer(timeRemaining: timeRemaining, name: name)
        timers.append(newTimer)
        bottomDuration = max(bottomDuration, newTimer.duration)
        newTimer.start()
    }
    
    func getTimerByNotifID(notifID: String) -> SingleTimer? {
        let matchingTimers = timers.filter { timer in
            return (timer.notifID == notifID)
        }
        
        if matchingTimers.count == 1 {
            return matchingTimers[0]
        } else {
            return nil
        }
    }
                   
    // not sure what this function is, I think it's the background handler?
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("notif received in background")
        
        guard let timer = getTimerByNotifID(notifID: response.notification.request.identifier) else {
            return
        }

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
        
        timer.foregroundDoneHandler()
    }
    
    // MARK: DownUp
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func dataModelURL() -> URL {
        let docURL = documentsDirectory()
        return docURL.appendingPathComponent(dataFileName)
    }

    func saveDownUpTimer() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(["downupTimer": downupTimer]) {
            do {
                // Save the 'downupTimer' data file to the Documents directory.
                try encoded.write(to: dataModelURL())
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
    
    func loadDownUpTimer(completion: @escaping (Result<[String: DownUpTimer], Error>) -> Void) {
//        DispatchQueue.main.async {
//            print("Loading override DownUp")
//            let firstDownUp = DownUpTimer()
//            firstDownUp.setTimerCallback()
//            completion(.success(["downupTimer": firstDownUp]))
//        }
//

        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = self.dataModelURL()
                // If loading fails
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(["downupTimer": DownUpTimer()]))
                    }
                    return
                }

                // Successful loading
                let results = try JSONDecoder().decode([String: DownUpTimer].self, from: file.availableData)
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
