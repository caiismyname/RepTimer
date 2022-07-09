//
//  ViewExtensions.swift
//  RepTimer
//
//  Created by David Cai on 7/9/22.
//

import Foundation
import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        }
        else {
            return AnyView(self)
        }
    }
}
