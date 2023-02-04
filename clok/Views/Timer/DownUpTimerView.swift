//
//  DownUpTimerView.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import SwiftUI
import WidgetKit

struct DownUpTimerView: View {
    @ObservedObject var controller = DownUpTimer()
    @Environment(\.scenePhase) private var scenePhase // Used for detecting when this scene is backgrounded and isn't currently visible.
    
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                if controller.status == .inactive {
                    Spacer()
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
                        TimeInputDisplay(keyboard: controller.keyboard)
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
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    controller.save()
//                    WidgetCenter.shared.reloadTimelines(ofKind: "TimerWidgets")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
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
            .font(controller.status == DownUpTimerStatus.inactive ? .system(size: Sizes.fontSize) : .system(size: Sizes.bigTimeFont)) // Controls the button font sizes
            .minimumScaleFactor(0.01)
    }
}

struct DUTimerView: View {
    @ObservedObject var model: SingleTimer
    
    var body: some View {
        Text(model.timeRemaining.formattedTimeNoMilliNoLeadingZeroRoundUpOneSecond)
            .bold()
            .lineLimit(1)
    }
}

struct DUStopwatchView: View {
    @ObservedObject var model: SingleStopWatch
    
    var body: some View {
        Text(model.duration.formattedTimeNoMilliNoLeadingZero)
            .bold()
            .lineLimit(1)
    }
}

struct DUDirectionIndicator: View {
    var direction: DownUpTimerDirection
    var status: DownUpTimerStatus
    
    var body: some View {
        if status == .active {
            if direction == .counting_down {
                Image(systemName: "arrow.down.circle.fill")
            } else if direction == .counting_up {
                Image(systemName: "arrow.up.circle")
            }
        } else if status == .paused {
            Image(systemName: "pause.circle.fill")
        }
    }
}

struct DUVisualization: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var stopwatch: SingleStopWatch
    @ObservedObject var controller: DownUpTimer
    let circleWidth = 20.0
    
    var body: some View {
        GeometryReader { gp in
            VStack {
                HStack {
                    DUDirectionIndicator(
                        direction: controller.currentDirection,
                        status: controller.status
                    )
                    
                    Spacer()
                    
                    Text("Cycles: \(controller.cycleCount)")
                        .font(.system(size: Sizes.fontSize))
                }
                .padding([.top], 0)
                
                ZStack {
                    Circle().stroke(Color.gray, lineWidth: circleWidth)
                    if controller.currentDirection == .counting_down {
                        Circle()
                            .trim(from: 0.0, to: Double(timer.timeRemaining / timer.duration))
                            .stroke(style: StrokeStyle(lineWidth: circleWidth, lineCap:.round))
                            .rotationEffect(Angle(degrees: 270.0))
                        
                        VStack {
                            DUTimerView(model: timer)
                            HStack {
                                Image(systemName: "stopwatch")
                                Text("\(controller.totalDurationStopwatch.duration.formattedTimeNoMilliNoLeadingZero)")
                            }
                            .font(Font.monospaced(.system(size: Sizes.fontSize))())
                        }
                        .padding()
                    } else if controller.currentDirection == .counting_up {
                        VStack {
                            DUStopwatchView(model: controller.stopwatch)
                            HStack {
                                Image(systemName: "stopwatch")
                                Text("\(controller.totalDurationStopwatch.duration.formattedTimeNoMilliNoLeadingZero)")
                            }
                            .font(Font.monospaced(.system(size: Sizes.fontSize))())
                        }
                        .padding()
                    }
                    
                    //                HStack {
                    //                    if controller.currentDirection == .counting_down {
                    //                        Image(systemName: "arrow.down.circle.fill")
                    //                    } else if controller.currentDirection == .counting_up {
                    //                        Image(systemName: "arrow.up.circle")
                    //                    }
                    //
                    //                    Spacer()
                    //
                    //                    Text("Cycles: \(controller.cycleCount)")
                    //                        .font(.system(size: Sizes.fontSize))
                    //                }.position(x: gp.size.width / 2, y: Sizes.bigTimeFont / 2)
                }
            }
        }
        .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
        .minimumScaleFactor(0.1)
    }
}

struct DownUpTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DownUpTimer()
        
        DownUpTimerView(controller: model)
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.dark)
    }
}
