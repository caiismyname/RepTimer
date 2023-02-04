//
//  Clok_WidgetsBundle.swift
//  Clok Widgets
//
//  Created by David Cai on 2/3/23.
//

import WidgetKit
import SwiftUI

@main
struct Clok_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        Clok_WidgetsLiveActivity()
    }
}
