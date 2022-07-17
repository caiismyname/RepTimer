//
//  TimerContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerContainerView: View {
    @ObservedObject var timelineController: TimersController
    
    var body: some View {
        TimerTimelineView(controller: timelineController)
    }
}

struct TimerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineController = TimersController()
        Group {
            TimerContainerView(
                timelineController: timelineController
            )
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
