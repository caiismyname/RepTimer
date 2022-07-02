//
//  StopWatchHistoryView.swift
//  RepTimer
//
//  Created by David Cai on 7/2/22.
//

import Foundation
import SwiftUI

struct StopWatchHistoryView: View {
    @ObservedObject var controller: StopwatchesController
    @State var isDetailPopupShowing = false
    @State var popoverStopwatchIdx = 0
    
    var body: some View {
        VStack (alignment: .leading){
            Text("History")
            .font(.system(size: 40, weight: .bold))
            .minimumScaleFactor(0.01)
            
            List {
                ForEach(controller.pastStopwatches.indices, id:\.self) { idx in
                    MultipleStopWatchView(stopwatch: controller.pastStopwatches[idx])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.popoverStopwatchIdx = idx
                        self.isDetailPopupShowing = true
                    }
                }
            }
            .listStyle(.plain)
            .popover(isPresented: self.$isDetailPopupShowing) {
                SingleStopWatchView(stopwatch: controller.pastStopwatches[popoverStopwatchIdx])
                .padding()
            }
        }
    }
}


struct StopWatchHistory_Previews: PreviewProvider {
    static var previews: some View {
        let controller = StopwatchesController()
        Group {
            StopWatchHistoryView(controller: controller)
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

