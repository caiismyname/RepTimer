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
    @State var isHistoryPopupShowing = false

    var body: some View {
        VStack (alignment: .trailing) {
            HStack {
                Button(action: {isHistoryPopupShowing = true}) {
                    Image(systemName: "list.bullet.circle")
                }
                Button(action: {
                    controller.newStopwatch()
                }) {
                    Image(systemName: "plus.circle")
                }
            }
            .font(.system(size: 35))
            .padding(.trailing, 20)
            .popover(isPresented: self.$isHistoryPopupShowing) {
                StopWatchHistoryView(controller: controller)
                .padding()
            }

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
                        controller.stopwatches[indexSet.first!].reset() // using .first because there should only be one value in the indexSet
                        controller.stopwatches.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .popover(isPresented: self.$isDetailPopupShowing) {
                    SingleStopWatchView(stopwatch: controller.stopwatches[popoverStopwatchIdx])
                    .padding()
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
        .preferredColorScheme(.dark)
    }
  }
}
