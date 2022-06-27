//
//  TimerTimelineView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerTimelineView: View {
    @ObservedObject var controller: TimelineController
    @State var createTimerPopoverShowing = false
    let verticalFidelity = 20.0
    
    // Compute Y Position for a given timer, returned as fraction of the full height of the timeline
    func computeYPos(timer: SingleTimer) -> Double {
        return (timer.timeRemaining / controller.bottomDuration) * verticalFidelity
    }
    
    func saveNewTimer(name: String, duration: TimeInterval) {
        if duration > 0.0 {
            controller.addTimer(timeRemaining: duration, name: name)
            createTimerPopoverShowing = false
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing)  {
            Button(action: {createTimerPopoverShowing = true}) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
                }
            .padding(.trailing, 20)
            .popover(isPresented: $createTimerPopoverShowing) {
                CreateTimerView(saveFunc: saveNewTimer)
                    .padding()
            }
                
            GeometryReader { proxy in
                // Background grid
                ForEach(0...10, id: \.self) {offset in
                    Rectangle()
                        .fill(Color(UIColor.gray))
                        .frame(width: proxy.size.width, height: 1)
                        .position(x: proxy.size.width / 2, y: (proxy.size.height / 10) * CGFloat(offset))
                }
                
                // Plot each timer
                ForEach(controller.timers, id: \.self) { timer in
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
    }
}

struct TimerTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = TimelineController()
        Group {
            TimerTimelineView(controller: controller)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
