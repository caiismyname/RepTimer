//
//  StopwatchSettingsView.swift
//  RepTimer
//
//  Created by David Cai on 7/3/22.
//

import Foundation
import SwiftUI

enum StopwatchSettings: String {
    case LAP_VIA_SCREENSHOT
    case SCREEN_LOCK
}

struct StopwatchSettingsView: View {
//    @ObservedObject var model = StopwatchSettingsModel()
    @AppStorage(StopwatchSettings.SCREEN_LOCK.rawValue) var isScreenLock: Bool = false
    @AppStorage(StopwatchSettings.LAP_VIA_SCREENSHOT.rawValue) var isLapViaScreenshot: Bool = true
    
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Stopwatch Settings")
            .font(.system(size: 40, weight: .bold))
            .minimumScaleFactor(0.01)
            
            List {
                Text("Lap-via-screenshot enables you to trigger a lap by taking a screenshot (volume up + power button). Useful if you need to lap without looking at your phone.")
                Toggle("Enable lap-via-screenshot", isOn: $isLapViaScreenshot)
            }
            
            List {
                Text("Screen lock will keep the screen on and ignore any inputs until it is disabled. Enable/disable screen lock by tapping the screen five times.")
            }
            
        }
    }
}


struct StopwatchSettings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StopwatchSettingsView()
                .previewInterfaceOrientation(.portrait)
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}

