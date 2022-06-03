//
//  ContentView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var rep: Rep
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var body: some View {
        VStack {
            RepTimeView(rep: rep)
            
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
