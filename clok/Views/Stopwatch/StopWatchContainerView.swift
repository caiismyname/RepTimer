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
    @AppStorage(StopwatchSettings.SCREEN_LOCK.rawValue) var isScreenLocked: Bool = false
    @State var isSettingsPopupShowing = false
    @State var isHistoryPopupShowing = false
    
    let haptic = UIImpactFeedbackGenerator(style: .heavy)
    let screenLockHaptic = UINotificationFeedbackGenerator()
    let buttonSize = Sizes()

    var body: some View {
        VStack (alignment: .trailing) {
            // Row of settings buttons at top
            HStack {
                Button(action: {
                    if !isScreenLocked {
                        isSettingsPopupShowing = true
                    }
                }) {Image(systemName: "gearshape.circle")}
                Button(action: {
                    if !isScreenLocked {
                        isHistoryPopupShowing = true
                    }
                }) {Image(systemName: "list.bullet.circle")}
                Spacer()
                Button(action: {
                    if !isScreenLocked {
                        controller.newStopwatch()
                        haptic.impactOccurred()
                    }
                }) {Image(systemName: "plus.circle")}
            }
            .font(.system(size: buttonSize.inputIconSize))
            .padding([.leading, .trailing, .top])
            .popover(isPresented: self.$isHistoryPopupShowing) {
                StopWatchHistoryView(controller: controller)
                .padding()
            }
            .popover(isPresented: self.$isSettingsPopupShowing) {
                StopwatchSettingsView()
                .padding()
            }
            
            // Stopwatch(es)
            if (controller.stopwatches.count == 1) {
                SingleStopWatchView(stopwatch: controller.stopwatches[0])
                    .padding([.leading, .trailing, .bottom])
            } else {
                List {
                    ForEach(controller.stopwatches.indices, id:\.self) { idx in
                        MultipleStopWatchView(stopwatch: controller.stopwatches[idx])
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !isScreenLocked {
                                controller.popoverStopwatchIdx = idx
                                controller.isDetailPopupShowing = true
                            }
                        }
                    }
                    .onDelete
                    { indexSet in
                        if !isScreenLocked {
                            controller.stopwatches[indexSet.first!].reset() // using .first because there should only be one value in the indexSet
                            controller.stopwatches.remove(atOffsets: indexSet)
                        }
                    }
                }
                .listStyle(.plain)
                .popover(isPresented: $controller.isDetailPopupShowing) {
                    SingleStopWatchView(stopwatch: controller.stopwatches[controller.popoverStopwatchIdx])
                    .padding()
                }
            }
        }
        .overlay(isScreenLocked ? RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 2) : nil)
        .onTapGesture(count: 5, perform: {
            isScreenLocked = !isScreenLocked
            screenLockHaptic.notificationOccurred(.error)
            if isScreenLocked {
                UIApplication.shared.isIdleTimerDisabled = true
            } else {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        })
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
