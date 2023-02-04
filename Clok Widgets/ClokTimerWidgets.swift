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
            let currentDate = Date()
            
            // Generate entry for current segment
            let entry = TimerWidgetEntry(
                date: Date(),
                configuration: configuration,
                targetDate: loadedTimer.currentDirection == .counting_up ? loadedTimer.stopwatch.createDate : loadedTimer.timer.scheduledEndTime,
                direction: loadedTimer.currentDirection,
                status: loadedTimer.status
            )
            entries.append(entry)
            
            // If counting down, generate an entry for when it switches
            if loadedTimer.currentDirection == .counting_down {
                let entry = TimerWidgetEntry(
                    date: loadedTimer.timer.scheduledEndTime,
                    configuration: configuration,
                    targetDate: loadedTimer.timer.scheduledEndTime,
                    direction: DownUpTimerDirection.counting_up,
                    status: DownUpTimerStatus.active
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

struct DUSmallWidgetView: View {
    var entry: TimerWidgetProvider.Entry
    
    var body: some View {
        if entry.status != .inactive {
            VStack(alignment: .center) {
                DUDirectionIndicator(direction: entry.direction, status: entry.status)
                
                Group {
                    if entry.status == .active {
                        Text(entry.targetDate, style: .timer)
                    } else {
                        Text("Timer paused")
                    }
                }
                    .padding([.leading, .trailing])
            }
                .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        } else {
            Text("No timer\nrunning")
                .padding()
        }
    }
}


struct DUMediumWidgetView: View {
    var entry: TimerWidgetProvider.Entry
    
    var body: some View {
        if entry.status != .inactive {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Spacer()
                    DUDirectionIndicator(direction: entry.direction, status: entry.status)
                    
                    if entry.status == .active {
                        Text(entry.targetDate, style: .timer)
                    } else {
                        Text("Timer paused")
                    }
                }
                .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
                .minimumScaleFactor(0.1)
                .lineLimit(1)
            }
        } else {
            Text("No timer\nrunning")
                .padding()
        }
    }
}




struct DownupWidgetView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: TimerWidgetProvider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: DUSmallWidgetView(entry: entry)
        case .systemMedium: DUMediumWidgetView(entry: entry)
        default: DUSmallWidgetView(entry: entry)
        }
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
            DownupWidgetView(entry: entry)
        }
        .configurationDisplayName("Repeat Timer")
        .description("Displays the currently running interval timer")
    }
}

struct TimerWidget_Previews: PreviewProvider {
    static var previews: some View {
        DownupWidgetView(
            entry: TimerWidgetEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                targetDate: Date().addingTimeInterval(90),
                direction: .counting_down,
                status: .active
            )
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")
        
        DownupWidgetView(
            entry: TimerWidgetEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                targetDate: Date().addingTimeInterval(90),
                direction: .counting_down,
                status: .active
            )
        )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")
    }
}
