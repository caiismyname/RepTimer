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
    @State private var isDetailPopupShowing = false
    @State private var popoverStopwatchID = UUID()

    var body: some View {
        VStack (alignment: .trailing) {
            Button(action: {controller.addStopwatch()}) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
            }
            .padding(.trailing, 20)
            .popover(isPresented: self.$isDetailPopupShowing) {
                SingleStopWatchView(stopwatch: controller.getStopwatch(id: popoverStopwatchID) ?? SingleStopWatch()).padding()
            }

            if (controller.stopwatches.count == 1) {
                SingleStopWatchView(stopwatch: controller.stopwatches[0])
            } else {
                List {
                    ForEach(controller.stopwatches) { stopwatch in
                        MultipleStopWatchView(stopwatch: stopwatch)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print(isDetailPopupShowing)
                            self.popoverStopwatchID = stopwatch.id
                            isDetailPopupShowing = true
                        }
                    }
                    .onDelete { indexSet in
                        controller.stopwatches.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
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


