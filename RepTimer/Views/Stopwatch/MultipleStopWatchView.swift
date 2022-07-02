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
    @ObservedObject var stopwatch: SingleStopWatch
    let secondaryTextSize = CGFloat(18)
    @State private var detailPopupShowing = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(stopwatch.displayFormatted)
            .font(.system(size: 50, weight: .regular , design: .monospaced))
            .minimumScaleFactor(0.01)
            Text("\(stopwatch.laps.count) laps")
                .font(Font.monospaced(.system(size: secondaryTextSize))())
                .padding(.leading, 7)
            StopWatchControlsView(stopwatch: stopwatch)
        }
    }
}

struct MultipleStopWatchView_Previews: PreviewProvider {
  static var previews: some View {
    let stopwatch = SingleStopWatch()
    Group {
        MultipleStopWatchView(stopwatch: stopwatch)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}

