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
                // Timer display
                HStack {
                    if controller.status == DownUpTimerStatus.inactive {
                        DUTimeInputView(keyboard: controller.keyboard)
                    }
                }
                .padding()
                
                // Input keyboard / visualization
                if controller.status == DownUpTimerStatus.inactive {
                    TimeInputKeyboardView(model: controller.keyboard)
                } else {
                    DUVisualization(timer: controller.timer, stopwatch:  controller.stopwatch, controller: controller)
                }
                
                Spacer()
                
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
    
    var body: some View {
        HStack {
            if controller.status != DownUpTimerStatus.inactive {
                Button(action: {
                    controller.stop()
                    haptic.impactOccurred()
                }) {
                    Image(systemName: "stop.circle")
                }
                .frame(maxWidth: outerWidth / 10, maxHeight: outerHeight / 9)
                .padding(30)
                .background(Color.red)
                .cornerRadius(12)
                .font(.system(size: 50))
                .minimumScaleFactor(0.01)
            }
            
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
            }
            .frame(maxWidth: .infinity, maxHeight: outerHeight / 9)
            .padding(30)
            .background(Color.green)
            .cornerRadius(12)
            .font(.system(size: 100))
            .minimumScaleFactor(0.01)
        }
        .foregroundColor(Color.white)
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
        .font(Font.monospaced(.system(size: 80))())
        .minimumScaleFactor(0.1)
        .lineLimit(1)
    }
}

struct DUVisualization: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var stopwatch: SingleStopWatch
    @ObservedObject var controller: DownUpTimer
    let circleWidth = 20.0
    let fontSize = 80.0
    
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
                    .position(x: fontSize / 2, y: fontSize / 2)
                } else if controller.status == DownUpTimerStatus.counting_up {
                    Image(systemName: "arrow.up.circle")
                    .position(x: fontSize / 2, y: fontSize / 2)
                }
            }
        }
        .font(Font.monospaced(.system(size: fontSize))())
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
