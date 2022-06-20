//
//  TimerContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerContainerView: View {
    @StateObject var timelineController: TimelineController
    
    var body: some View {
        TimerTimelineView(controller: timelineController)
    }
}

struct TimerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineController = TimelineController()
        Group {
            TimerContainerView(
                timelineController: timelineController
            )
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
