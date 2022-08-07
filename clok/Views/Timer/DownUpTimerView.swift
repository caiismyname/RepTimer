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
    let buttonSize = Sizes()
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
                    controller.reset()
                    haptic.impactOccurred()
                }) {
                    Image(systemName:
                        controller.status == DownUpTimerStatus.inactive ? "play.circle" : "arrow.counterclockwise.circle"
                    )
                    .frame(maxWidth: .infinity, maxHeight: buttonSize.inputHeight)
                }
                .background(Color.green)
                .cornerRadius(buttonSize.radius)
            } else {
                // Stop button
                Button(action: {
                    controller.stop()
                    haptic.impactOccurred()
                }) {
                    Image(systemName: "stop.circle")
                    .frame(maxWidth: outerWidth / 10, maxHeight: bigButtonHeight())
                    .padding(30)
                }
                .background(Color.red)
                .cornerRadius(buttonSize.radius)
                
                // Reset button
                Button(action: {
                    if controller.status == DownUpTimerStatus.inactive {
                        controller.timerDuration = keyboard.value
                    }
                    controller.reset()
                    haptic.impactOccurred()
                }) {
                    Image(systemName:
                            controller.status == DownUpTimerStatus.inactive ? "play.circle" : "arrow.counterclockwise.circle"
                    )
                    .frame(maxWidth: .infinity, maxHeight: bigButtonHeight())
                    .padding(30)
                }
                .background(Color.green)
                .cornerRadius(buttonSize.radius)
            }
        }
        .foregroundColor(Color.white)
        .font(controller.status == DownUpTimerStatus.inactive ? .system(size: buttonSize.fontSize) : .system(size: 55))
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
    let sizes = Sizes()
    
    var body: some View {
        Text(keyboard.value.formattedTimeNoMilliNoLeadingZero)
        .font(Font.monospaced(.system(size: sizes.bigTimeFont))())
        .minimumScaleFactor(0.1)
        .lineLimit(1)
    }
}

struct DUVisualization: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var stopwatch: SingleStopWatch
    @ObservedObject var controller: DownUpTimer
    let circleWidth = 20.0
    let sizes = Sizes()
    
    var body: some View {
        GeometryReader { gp in
            ZStack {
                Circle().stroke(Color.gray, lineWidth: circleWidth)
                if controller.status == DownUpTimerStatus.counting_down {
                    Circle()
                    .trim(from: 0.0, to: Double(timer.timeRemaining / timer.duration))
                    .stroke(style: StrokeStyle(lineWidth: circleWidth, lineCap:.round))
                    .rotationEffect(Angle(degrees: 270.0))
                    
                    DUTimerView(model: timer)
                    .padding()
                } else if controller.status == DownUpTimerStatus.counting_up {
                    DUStopwatchView(model: stopwatch)
                    .padding()
                }
                
                if controller.status == DownUpTimerStatus.counting_down {
                    Image(systemName: "arrow.down.circle.fill")
                        .position(x: sizes.bigTimeFont / 2, y: sizes.bigTimeFont / 2)
                } else if controller.status == DownUpTimerStatus.counting_up {
                    Image(systemName: "arrow.up.circle")
                    .position(x: sizes.bigTimeFont / 2, y: sizes.bigTimeFont / 2)
                }
            }
        }
        .font(Font.monospaced(.system(size: sizes.bigTimeFont))())
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
