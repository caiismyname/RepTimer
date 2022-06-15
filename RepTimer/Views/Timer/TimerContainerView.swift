//
//  TimerContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/13/22.
//

import Foundation
import SwiftUI

struct TimerContainerView: View {
    
    var body: some View {
        TimerTimelineView()
    }
}

struct TimerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerContainerView()
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 13 Pro")
        }
    }
}
