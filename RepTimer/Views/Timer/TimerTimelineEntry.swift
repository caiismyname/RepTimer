//
//  TimerTimelineEntry.swift
//  RepTimer
//
//  Created by David Cai on 6/20/22.
//

import Foundation
import SwiftUI

struct TimelineEntryView: View {
    @StateObject var timer: SingleTimer
    let proxy: GeometryProxy
    let verticalFidelity: Double
    let bottomDuration: Double
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.green))
                .frame(width: 200, height: 20)
            Text("\(timer.timeRemaining.formattedTimeNoMilli)")
                .font(Font.monospaced(.system(size:15))())
        }.position(
            x: proxy.size.width / 3,
            y: (proxy.size.height / verticalFidelity) * ((timer.timeRemaining / bottomDuration) * verticalFidelity)
        )
    }
}

//struct TimelineEntryView_Previews: PreviewProvider {
//  static var previews: some View {
//    let timer = SingleTimer(timeRemaining: 5)
//    
//    Group {
//        TimelineEntryView(timer: timer)
//            .previewInterfaceOrientation(.portrait)
//            .previewDevice("iPhone 13 Pro")
//    }
//  }
//}
