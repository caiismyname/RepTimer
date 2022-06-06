//
//  ContentView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var stopwatch: StopWatch
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var body: some View {
        VStack {
            StopWatchView(stopwatch: stopwatch)
            
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
