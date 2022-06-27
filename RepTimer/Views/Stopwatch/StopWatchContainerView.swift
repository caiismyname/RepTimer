//
//  StopWatchContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI

struct StopWatchContainerView: View {
    @ObservedObject var controller: StopwatchesController
    @State var isDetailPopupShowing = false
    @State var popoverStopwatchIdx = 0

    var body: some View {
        VStack (alignment: .trailing) {
            Button(action: {controller.stopwatches.append(SingleStopWatch())}) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
            }
            .padding(.trailing, 20)

            if (controller.stopwatches.count == 1) {
                SingleStopWatchView(stopwatch: controller.stopwatches[0])
            } else {
                List {
                    ForEach(controller.stopwatches.indices, id:\.self) { idx in
                        MultipleStopWatchView(stopwatch: controller.stopwatches[idx])
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.popoverStopwatchIdx = idx
                            self.isDetailPopupShowing = true
                        }
                    }
                    .onDelete { indexSet in
                        controller.stopwatches.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .popover(isPresented: self.$isDetailPopupShowing) {
                    SingleStopWatchView(stopwatch: controller.stopwatches[popoverStopwatchIdx])
                }
            }
        }
    }
}

struct StopWatchContainer_Previews: PreviewProvider {
  static var previews: some View {
    let controller = StopwatchesController()
    Group {
        StopWatchContainerView(controller: controller)
        .previewInterfaceOrientation(.portrait)
        .previewDevice("iPhone 13 Pro")
    }
  }
}
