//
//  MultipleStopWatchView.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI

// This is how a single StopWatch looks when there are multiple of them in a container.
struct MultipleStopWatchView: View {
    @StateObject var stopwatch: StopWatch
    let secondaryTextSize = CGFloat(18)
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(stopwatch.displayFormatted)
                .font(Font.monospaced(.system(size: 50))())
                .minimumScaleFactor(0.01)
            Text("\(stopwatch.laps.count) laps")
                .font(Font.monospaced(.system(size: secondaryTextSize))())
                .minimumScaleFactor(1)
                .padding(.leading, 7)
            StopWatchControlsView(stopwatch: stopwatch)
        }
    }
}

struct MultipleStopWatchView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = StopWatch()
    Group {
        MultipleStopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}

