//
//  TimerTimelineView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerTimelineView: View {
    @StateObject var controller: TimerTimelineController = TimerTimelineController()
    let verticalFidelity = 20.0
    
    // Compute Y Position for a given timer, returned as fraction of the full height of the timeline
    func computeYPos(timer: SingleTimer) -> Double {
        return (timer.timeRemaining / controller.bottomDuration) * verticalFidelity
    }
    
    func saveNewTimer() {
        let newTimerDuration = Double(Int.random(in: 0..<100))
        controller.addTimer(timeRemaining: TimeInterval(newTimerDuration))
    }
    
    var body: some View {
        VStack(alignment: .trailing)  {
            Button(action: saveNewTimer) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
                }.padding(.trailing, 20)
            GeometryReader { proxy in
                // Background grid
                ForEach(0...10, id: \.self) {offset in
                    Rectangle()
                        .fill(Color(UIColor.blue))
                        .frame(width: proxy.size.height, height: 1)
                        .position(x: 0, y: (proxy.size.height / 10) * CGFloat(offset))
                }
                
                // Plot each timer
                ForEach(controller.timers, id: \.self) { timer in
                    ZStack {
                        Rectangle()
                            .fill(Color(UIColor.green))
                            .frame(width: 200, height: 20)
                        Text("\(timer.timeRemaining)")
                    }.position(x: proxy.size.width / 3, y: (proxy.size.height / verticalFidelity) * computeYPos(timer: timer))
                }
            }
                .border(Color.red)
        }
    }
}

struct TimerTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            TimerTimelineView()
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
