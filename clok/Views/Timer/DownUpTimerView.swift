//
//  DownUpTimerView.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import SwiftUI

struct DownUpTimerView: View {
    @ObservedObject var controller: DownUpTimer
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                Spacer()
                
                if controller.status == .inactive {
                    // Starting direction control
                    HStack {
                        Text("Starting direction")
                            .font(.system(.body))
                        Picker("Starting direction", selection: $controller.startingDirection) {
                            Text("Down").tag(DownUpTimerDirection.counting_down)
                            Text("Up").tag(DownUpTimerDirection.counting_up)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                }
                
                // Timer display
                HStack {
                    if controller.status == DownUpTimerStatus.inactive {
                        DUTimeInputView(keyboard: controller.keyboard)
                    }
                }
                .padding()
                
                
                // Input keyboard / visualization
                if controller.status == DownUpTimerStatus.inactive {
                    Spacer()
                    TimeInputKeyboardView(model: controller.keyboard)
                } else {
                    DUVisualization(timer: controller.timer, stopwatch:  controller.stopwatch, controller: controller)
                }
                
                // Controls
                DUControlsView(controller: controller, keyboard: controller.keyboard, outerHeight: geo.size.height, outerWidth: geo.size.width)
            }
        }
        .padding()
    }
}

struct DUControlsView: View {
    @ObservedObject var controller: DownUpTimer
    @ObservedObject var keyboard: TimeInputKeyboardModel
    let haptic = UIImpactFeedbackGenerator(style: .heavy)
    var outerHeight: Double
    var outerWidth: Double
    
    func bigButtonHeight() -> Double {
        return outerHeight / 9
    }
    
    var body: some View {
        HStack {
            if controller.status == DownUpTimerStatus.inactive {
                // Start button
                Button(action: {
                    if controller.status == DownUpTimerStatus.inactive {
                        controller.timerDuration = keyboard.value
                    }
                    controller.nextPhase()
                    haptic.impactOccurred()
                }) {
                    Image(systemName:
                        controller.status == DownUpTimerStatus.inactive ? "play.circle" : "arrow.counterclockwise.circle"
                    )
                    .frame(maxWidth: .infinity, maxHeight: Sizes.inputHeight)
                }
                .background(Color.green)
                .cornerRadius(Sizes.radius)
            } else if controller.status == .paused {
                // Stop button
                Button(action: {
                    controller.reset()
                    haptic.impactOccurred()
                }) {
                    Image(systemName: "trash")
                        .frame(maxWidth: outerWidth / 10, maxHeight: bigButtonHeight())
                        .padding(30)
                }
                .background(Color.red)
                .cornerRadius(Sizes.radius)
                
                // Next button
                Button(action: {
                    if controller.status == DownUpTimerStatus.inactive {
                        controller.timerDuration = keyboard.value
                    }
                    controller.nextPhase()
                    haptic.impactOccurred()
                }) {
                    Image(systemName: "play.circle")
                        .frame(maxWidth: .infinity, maxHeight: bigButtonHeight())
                        .padding(30)
                }
                .background(Color.green)
                .cornerRadius(Sizes.radius)
            } else if controller.status == .active {
                // Stop button
                Button(action: {
                    controller.pause()
                    haptic.impactOccurred()
                }) {
                    Image(systemName: "pause.circle")
                    .frame(maxWidth: outerWidth / 10, maxHeight: bigButtonHeight())
                    .padding(30)
                }
                .background(Color.red)
                .cornerRadius(Sizes.radius)
                
                // Next button
                Button(action: {
                    if controller.status == .inactive {
                        controller.timerDuration = keyboard.value
                    }
                    controller.nextPhase()
                    haptic.impactOccurred()
                }) {
                    Image(systemName:
                            controller.status == DownUpTimerStatus.inactive ? "play.circle" : "arrow.forward.to.line"
                    )
                    .frame(maxWidth: .infinity, maxHeight: bigButtonHeight())
                    .padding(30)
                }
                .background(Color.green)
                .cornerRadius(Sizes.radius)
            }
        }
        .foregroundColor(Color.white)
        .font(controller.status == DownUpTimerStatus.inactive ? .system(size: Sizes.fontSize) : .system(size: 55))
        .minimumScaleFactor(0.01)
    }
}

struct DUTimerView: View {
    @ObservedObject var model: SingleTimer
    
    var body: some View {
        Text(model.timeRemaining.formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond)
        .lineLimit(1)
    }
}

struct DUStopwatchView: View {
    @ObservedObject var model: SingleStopWatch
    
    var body: some View {
        Text(model.duration.formattedTimeNoMilliNoLeadingZero)
        .lineLimit(1)
    }
}

struct DUTimeInputView: View {
    @ObservedObject var keyboard: TimeInputKeyboardModel
    
    var body: some View {
        Text(keyboard.value.formattedTimeNoMilliNoLeadingZero)
        .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
        .minimumScaleFactor(0.1)
        .lineLimit(1)
    }
}

struct DUVisualization: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var stopwatch: SingleStopWatch
    @ObservedObject var controller: DownUpTimer
    let circleWidth = 20.0
    
    var body: some View {
        GeometryReader { gp in
            ZStack {
                Circle().stroke(Color.gray, lineWidth: circleWidth)
                if controller.currentDirection == .counting_down {
                    Circle()
                    .trim(from: 0.0, to: Double(timer.timeRemaining / timer.duration))
                    .stroke(style: StrokeStyle(lineWidth: circleWidth, lineCap:.round))
                    .rotationEffect(Angle(degrees: 270.0))
                    
                    DUTimerView(model: timer)
                    .padding()
                } else if controller.currentDirection == .counting_up {
                    DUStopwatchView(model: stopwatch)
                    .padding()
                }
                
                HStack {
                    if controller.currentDirection == .counting_down {
                        Image(systemName: "arrow.down.circle.fill")
//                            .position(x: sizes.bigTimeFont / 2, y: sizes.bigTimeFont / 2)
                    } else if controller.currentDirection == .counting_up {
                        Image(systemName: "arrow.up.circle")
//                            .position(x: sizes.bigTimeFont / 2, y: sizes.bigTimeFont / 2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Cycles: \(controller.cycleCount)")
                        Text("Total: \(controller.totalDurationStopwatch.duration.formattedTimeNoMilliNoLeadingZero)")
                    }
                    .font(Font.monospaced(.system(size: Sizes.smallFontSize))())
                }.position(x: gp.size.width / 2, y: Sizes.bigTimeFont / 2)
            }
        }
        .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
        .minimumScaleFactor(0.1)
    }
}

struct DownUpTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DownUpTimer()
        Group {
            DownUpTimerView(controller: model)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13")
                .preferredColorScheme(.dark)
        }
    }
}
