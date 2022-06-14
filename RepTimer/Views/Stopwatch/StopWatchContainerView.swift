//
//  StopWatchContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI

struct StopWatchContainerView: View {
    @StateObject var controller: StopWatchesController

    var body: some View {
        VStack (alignment: .trailing) {
            Button(action: {controller.addStopwatch()}) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
            }.padding(.trailing, 20)

            if (controller.stopwatches.count == 1) {
                SingleStopWatchView(stopwatch: controller.stopwatches[0])
            } else {
                List {
                    ForEach(controller.stopwatches) { stopwatch in
                        MultipleStopWatchView(stopwatch: stopwatch)
                    }
                    .onDelete { indexSet in
                        controller.stopwatches.remove(atOffsets: indexSet)
                    }
                }.listStyle(.plain)
            }
        }
    }
}

struct StopWatchContainer_Previews: PreviewProvider {
  static var previews: some View {
    let controller = StopWatchesController()
    Group {
        StopWatchContainerView(controller: controller)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}


