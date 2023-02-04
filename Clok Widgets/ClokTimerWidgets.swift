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
        TimerWidgetEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TimerWidgetEntry) -> ()) {
        let entry = TimerWidgetEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [TimerWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TimerWidgetEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TimerWidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct TimerWidgetEntryView : View {
    var entry: TimerWidgetProvider.Entry
//    var downupController: DownUpTimer

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: TimerWidgetProvider()) { entry in
            TimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Timer")
        .description("Shows your 4 active timers closest to completion")
    }
}

struct TimerWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimerWidgetEntryView(entry: TimerWidgetEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
