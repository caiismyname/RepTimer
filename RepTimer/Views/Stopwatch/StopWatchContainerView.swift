//
//  StopWatchContainerView.swift
//  RepTimer
//
//  Created by David Cai on 6/12/22.
//

import Foundation
import SwiftUI

struct StopWatchContainerView: View {
    @State var controller = [SingleStopWatch()]
    @State var isDetailPopupShowing = false
    @State var popoverStopwatchIdx = 0

    var body: some View {
        VStack (alignment: .trailing) {
            Button(action: {controller.append(SingleStopWatch())}) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
            }
            .padding(.trailing, 20)

            if (controller.count == 1) {
                SingleStopWatchView(stopwatch: controller[0])
            } else {
                List {
                    ForEach(controller.indices, id:\.self) { idx in
                        MultipleStopWatchView(stopwatch: controller[idx])
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.popoverStopwatchIdx = idx
                            self.isDetailPopupShowing = true
                        }
                    }
                    .onDelete { indexSet in
                        controller.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
                .popover(isPresented: self.$isDetailPopupShowing) {
                    SingleStopWatchView(stopwatch: controller[popoverStopwatchIdx]).padding()
                }
            }
        }
    }
}

struct StopWatchContainer_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        StopWatchContainerView()
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13 Pro")
    }
  }
}
