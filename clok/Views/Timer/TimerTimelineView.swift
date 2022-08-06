//
//  TimerTimelineView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerTimelineView: View {
    @ObservedObject var controller: TimersController
    @State var createTimerPopoverShowing = false
    let verticalFidelity = 14.0

    func saveNewTimer(name: String, duration: TimeInterval) {
        if duration > 0.0 {
            controller.addTimer(timeRemaining: duration, name: name)
            createTimerPopoverShowing = false
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing)  {
            GeometryReader { proxy in
                ZStack {

                    // Background grid
                    ForEach(0...10, id: \.self) {offset in
                        Rectangle()
                        .fill(Color(UIColor.gray))
                        .frame(width: proxy.size.width, height: 1)
                        .position(x: proxy.size.width / 2, y: (proxy.size.height / 10) * CGFloat(offset))
                    }
                    
                    TimelineDoneBarView(proxy: proxy, verticalFidelity: verticalFidelity, controller: controller)
                    
                    // Plot each timer
                    ForEach(controller.activeTimers, id: \.self) { timer in
                        TimelineEntryView(
                            timer: timer,
                            proxy: proxy,
                            verticalFidelity: verticalFidelity,
                            bottomDuration: controller.bottomDuration
                        )
                    }
                }
                .contentShape(Rectangle()) // Enables tap gestures to be recognized on non-opaque elements
                .onTapGesture(count: 2) {
                    createTimerPopoverShowing = true
                }
                
            }
            
            Button(action: {createTimerPopoverShowing = true}) {
                Image(systemName: "plus.circle")
                .font(.system(size: 30))
            }
            .padding(.trailing, 20)
            .popover(isPresented: $createTimerPopoverShowing) {
                CreateTimerView(saveFunc: saveNewTimer)
                    .padding()
            }
        }
    }
}

struct TimelineEntryView: View {
    @ObservedObject var timer: SingleTimer
    let proxy: GeometryProxy
    let verticalFidelity: Double
    let bottomDuration: Double
    
    func computeWidth() -> Double {
        return (proxy.size.width / 1.15)
    }
    
    func computeHeight() -> Double {
        return (proxy.size.height / verticalFidelity)
    }
    
    func computeYPos() -> Double {
        return (timer.timeRemaining / bottomDuration) * (proxy.size.height - computeHeight()) + (computeHeight() / 2)
    }

    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.white))
                .cornerRadius(20)
                .frame(width: computeWidth(), height: computeHeight())
            HStack {
                if (timer.name != "") {
                    Text(timer.name)
                        .font(.system(size:20))
                        .minimumScaleFactor(0.1)
                        .lineLimit(2)
                    Spacer()
                }
                if (timer.status == TimerStatus.active) {
                    // Round up so time hits 0:00 when the pill hits the top of the screen
                    Text(timer.timeRemaining.formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond)
                        .font(Font.monospaced(.system(size:20))())
                } else if (timer.status == TimerStatus.ended) {
                    Text(timer.timeRemaining.formattedTimeNoMilliNoLeadingZero)
                        .font(Font.monospaced(.system(size:20))())
                }
            }
            .padding()
            .foregroundColor(Color.black)
            .frame(maxWidth: computeWidth())
        }.position(
            x: proxy.size.width / 2,
            y: computeYPos()
        )
    }
}

struct TimelineDoneBarView: View {
    let proxy: GeometryProxy
    let verticalFidelity: Double
    let paddingSize = 12.0
    @ObservedObject var controller: TimersController
    @State var doneTimersPresented = false
    
    func computeHeight() -> Double {
        return proxy.size.height / verticalFidelity
    }

    
    var body: some View {
        if (controller.completedTimers.count > 0) {
            ZStack {
                Rectangle()
                .fill(Color(UIColor.blue))
                .popover(isPresented: $doneTimersPresented) {
                    TimelineDoneTimersPopover(controller: controller)
                    .padding()
                }
                
                HStack {
                    Spacer()
                    Image(systemName: "flag.checkered")
                    Text("\(controller.completedTimers.count) timer" + (controller.completedTimers.count > 1 ? "s" : "") + " done")
                    Spacer()
                }
                .padding(paddingSize)
            }
            .font(.system(size: 20))
            .frame(width: proxy.size.width, height: computeHeight())
            .position(x: proxy.size.width / 2, y: computeHeight() - (2 * paddingSize))
            .onTapGesture(count: 1, perform: {
                doneTimersPresented = true
            })
        }
    }
}

struct TimelineDoneTimersPopover: View {
    @ObservedObject var controller: TimersController
    
    var body: some View {
        VStack {
            Button(action: {controller.clearCompletedTimers()}) {
                Image(systemName: "clear.fill")
                .font(.system(size: 30))
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(12)
            
            List(controller.completedTimers, id: \.self) { timer in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(timer.duration.formattedTimeNoMilliNoLeadingZero)")
                        if (timer.name != "") {
                            Spacer()
                            Text("\(timer.name)")
                        }
                    }
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    
                    Text("Started: \(timer.startTime.displayTime) \(timer.startTime.displayDate) ")
                }
                .font(.system(size: 20))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            }
        }
    }
    
}

struct TimerTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = TimersController()
        Group {
            TimerTimelineView(controller: controller)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
                .preferredColorScheme(.dark)
        }
    }
}

