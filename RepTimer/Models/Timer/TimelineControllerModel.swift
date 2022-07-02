//
//  TimerTimelineModel.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import UserNotifications

class TimelineController: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var timers: [SingleTimer] = []
    @Published var bottomDuration: TimeInterval = TimeInterval(0) // The TimeInteral value that denotes "bottom of the screen"
    
    override init() {
        super.init()
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Error 1")
                print(error)
            }
        }
        
        // Define the custom actions.
        let timerDismissAction = UNNotificationAction(identifier: "TIMER_DISMISS_ACTION",
              title: "Dismiss",
              options: [])
        
        // Define the notification type
        let timerEndCategory =
              UNNotificationCategory(identifier: "TIMER_END",
              actions: [timerDismissAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        // Register the notification type.
        center.setNotificationCategories([timerEndCategory])
        
        // Set this object as the notification delegate
        center.delegate = self
//        center.getNotificationSettings(completionHandler: { settings in
//            if settings.authorizationStatus == .authorized  {
//                print("Notification permission granted")
//            }
//        })
    }
    
    func addTimer(timeRemaining: TimeInterval, name: String) {
        let newTimer = SingleTimer(timeRemaining: timeRemaining, name: name)
        timers.append(newTimer)
        bottomDuration = max(bottomDuration, newTimer.duration)
    }
                   
    // not sure what this function is
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("notif received func 1")
    }
    
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
         willPresent notification: UNNotification,
         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("got notif in foregaround")
        print(notification.request.identifier)
    }
}
