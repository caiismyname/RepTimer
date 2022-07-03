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
//    @State var isDetailPopupShowing = false
//    @State var popoverStopwatchIdx = controller.isDetailPopupShowing
    @State var isHistoryPopupShowing = false
    let haptic = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        VStack (alignment: .trailing) {
            HStack {
                Button(action: {isHistoryPopupShowing = true}) {
                    Image(systemName: "list.bullet.circle")
                }
                Button(action: {
                    controller.newStopwatch()
                    haptic.impactOccurred()
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
                            controller.popoverStopwatchIdx = idx
                            controller.isDetailPopupShowing = true
                        }
                    }
                    .onDelete { indexSet in
                        controller.stopwatches[indexSet.first!].reset() // using .first because there should only be one value in the indexSet
                        controller.stopwatches.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .popover(isPresented: $controller.isDetailPopupShowing) {
                    SingleStopWatchView(stopwatch: controller.stopwatches[controller.popoverStopwatchIdx])
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
