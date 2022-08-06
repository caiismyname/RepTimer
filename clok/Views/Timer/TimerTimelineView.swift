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
//    @State var editTimerPopoverShowing = false
    let sizes = buttonSizes()
    let verticalFidelity = 14.0

    func saveNewTimer(name: String, duration: TimeInterval) {
        if duration > 0.0 {
            controller.addTimer(timeRemaining: duration, name: name)
            createTimerPopoverShowing = false
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if (controller.activeTimers.isEmpty && controller.completedTimers.isEmpty) {
                    CreateTimerView(saveFunc: saveNewTimer)
                    .padding()
                } else {
                    
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
                            controller: controller,
                            proxy: proxy,
                            verticalFidelity: verticalFidelity,
                            bottomDuration: controller.bottomDuration
                        )
                        .onTapGesture(count: 1, perform: {
                            timer.inEditMode = true
                        })
                    }
                    
                    // Plus button
                    Button(action: {createTimerPopoverShowing = true}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: sizes.fontSize))
                    }
                    .position(x: proxy.size.width - sizes.fontSize, y: proxy.size.height - sizes.fontSize)
                    .popover(isPresented: $createTimerPopoverShowing) {
                        CreateTimerView(saveFunc: saveNewTimer)
                        .padding()
                    }
                }
            }
            .contentShape(Rectangle()) // Enables tap gestures to be recognized on non-opaque elements
            .onTapGesture(count: 2) { createTimerPopoverShowing = true}
        }
    }
}

struct TimelineEntryView: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var controller: TimersController
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
                        .font(.system(size: 12))
                        .minimumScaleFactor(0.1)
                        .lineLimit(2)
                    Spacer()
                }
                if (timer.status == TimerStatus.active) {
                    // Round up so time hits 0:00 when the pill hits the top of the screen
                    Text(timer.timeRemaining.formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond)
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
        .overlay() {
            if timer.inEditMode {
                EditTimerPopover(controller: controller, timer: timer, doneCallback: {timer.inEditMode = false})
                    .position(x: proxy.size.width / 2, y: computeYPos() - computeHeight() - 10.0)
            }
        }
    }
}

struct TimelineDoneBarView: View {
    let proxy: GeometryProxy
    let verticalFidelity: Double
    let sizes = buttonSizes()
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
                .padding()
            }
            .font(.system(size: sizes.fontSize))
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
    let buttonSize = buttonSizes()
    
    var body: some View {
        VStack {
            Button(action: {controller.clearCompletedTimers()}) {
                Image(systemName: "clear.fill")
                .frame(maxWidth: .infinity, maxHeight: buttonSize.inputHeight)
            }
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(buttonSize.radius)
            
            List(controller.completedTimers.reversed(), id: \.self) { timer in
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

struct EditTimerPopover: View {
    @ObservedObject var controller: TimersController
    @ObservedObject var timer: SingleTimer
    var doneCallback = {}
    let sizes = buttonSizes()
    
    var body: some View {
        Button(action: {
            timer.stop()
            controller.findAndMoveCompletedTimers()
            doneCallback()
        }) {
            Image(systemName: "trash.fill")
            .padding()
            .frame(maxHeight: sizes.inputHeight)
            
        }
        .background(.white)
        .foregroundColor(.red)
        .cornerRadius(sizes.radius)
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

