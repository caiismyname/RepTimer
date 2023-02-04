//
//  Clok_Widgets.swift
//  Clok Widgets
//
//  Created by David Cai on 2/3/23.
//

import WidgetKit
import SwiftUI
import Intents

struct TimerWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> TimerWidgetEntry {
        TimerWidgetEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            targetDate: Date().addingTimeInterval(90),
            direction: .counting_down,
            status: .active
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimerWidgetEntry) -> ()) {
        let entry = TimerWidgetEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            targetDate: Date().addingTimeInterval(90),
            direction: .counting_down,
            status: .active
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TimerWidgetEntry] = []
        if let loadedTimer = DownUpTimer.loadFromFile() {
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = TimerWidgetEntry(
                    date: entryDate,
                    configuration: configuration,
                    targetDate: loadedTimer.currentDirection == .counting_up ? loadedTimer.stopwatch.createDate : loadedTimer.timer.scheduledEndTime,
                    direction: loadedTimer.currentDirection,
                    status: loadedTimer.status
                )
                entries.append(entry)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimerWidgetEntry: TimelineEntry {
    var date: Date
    let configuration: ConfigurationIntent
    var targetDate: Date
    let direction: DownUpTimerDirection
    let status: DownUpTimerStatus
}

struct TimerWidgetEntryView : View {
    var entry: TimerWidgetProvider.Entry
//    var downupController: DownUpTimer

    var body: some View {
        if entry.status == .active {
            if entry.direction == .counting_up {
                Text(entry.targetDate, style: .timer)
            } else {
                Text(entry.targetDate, style: .timer)
            }
        } else {
            Text("No timer running")
        }
        
//        DUVisualization(timer: downupController.timer, stopwatch: downupController.stopwatch, controller: downupController)
    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: TimerWidgetProvider()
        ) { entry in
            TimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Timer")
        .description("Shows your 4 active timers closest to completion")
    }
}

//struct TimerWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerWidgetEntryView(entry: TimerWidgetEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
