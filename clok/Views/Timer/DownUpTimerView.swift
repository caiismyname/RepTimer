//
//  DownUpTimerView.swift
//  RepTimer
//
//  Created by David Cai on 7/14/22.
//

import Foundation
import SwiftUI

struct DownUpTimerView: View {
    @ObservedObject var model = DownUpTimer(timerDuration: 60)
    @StateObject var keyboard = TimeInputKeyboardModel()
    
    var body: some View {
        GeometryReader {geo in
            VStack {
                // Timer display
                Group {
                    if model.status == DownUpTimerStatus.counting_down {
                        DUTimerView(model: model.timer)
                    } else if model.status == DownUpTimerStatus.counting_up {
                        DUStopwatchView(model: model.stopwatch)
                    } else if model.status == DownUpTimerStatus.inactive {
                        Text("\(keyboard.value.formattedTimeNoMilliNoLeadingZero)")
                    }
                }
                .font(Font.monospaced(.system(size: 80))())
                .minimumScaleFactor(0.1)
                .padding()
                
                // Input keyboard / visualization
                if model.status == DownUpTimerStatus.inactive {
                    TimeInputKeyboardView(model: keyboard)
                }
                
                Spacer()
                
                // Controls
                DUControlsView(model: model, keyboard: keyboard, outerHeight: geo.size.height, outerWidth: geo.size.width)
            }
        }
    }
}

struct DUControlsView: View {
    @ObservedObject var model: DownUpTimer
    @ObservedObject var keyboard: TimeInputKeyboardModel
    var outerHeight: Double
    var outerWidth: Double
    
    var body: some View {
        HStack {
            if model.status != DownUpTimerStatus.inactive {
                Button(action: {model.stop()}) {
                    Image(systemName: "stop.circle")
                }
                .frame(maxWidth: outerWidth / 10, minHeight: outerHeight / 6)
                .padding(30)
                .background(Color.red)
                .cornerRadius(12)
                .font(.system(size: 50))
                .minimumScaleFactor(0.01)
            }
            
            Button(action: {
                if model.status == DownUpTimerStatus.inactive {
                    model.timerDuration = keyboard.value
                }
                model.reset()
            }) {
                Image(systemName:
                    model.status == DownUpTimerStatus.inactive ? "play.circle" : "gobackward"
                )
            }
            .frame(maxWidth: .infinity, minHeight: outerHeight / 6)
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
    }
}

struct DUStopwatchView: View {
    @ObservedObject var model: SingleStopWatch
    
    var body: some View {
        Text(model.duration.formattedTimeNoMilliNoLeadingZero)
    }
}

struct DUVisualization: View {
    @ObservedObject var timer: SingleTimer
    @ObservedObject var stopwatch: SingleStopWatch
    @ObservedObject var duModel: DownUpTimer
    
    var body: some View {
        Text("yay")
    }
}

struct DownUpTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DownUpTimer(timerDuration: 10)
        Group {
            DownUpTimerView(model: model)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 8")
//                .preferredColorScheme(.dark)
        }
    }
}
