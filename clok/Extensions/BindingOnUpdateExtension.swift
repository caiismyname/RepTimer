//
//  BindingOnUpdateExtension.swift
//  RepTimer
//
//  Created by David Cai on 7/3/22.
//

import Foundation
import SwiftUI

extension Binding {

    /// Adds a modifier for this Binding that fires an action when a specific
    /// value changes.
    ///
    /// You can use `updated` to trigger a side effect as the result of a
    /// `Binding` value changing.
    ///
    /// `updated` is called on the main thread. Avoid performing long-running
    /// tasks on the main thread. If you need to perform a long-running task in
    /// response to `value` changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState.updated { newState in
    ///                     model.playStateDidChange(newState)
    ///                 })
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A new binding value.
    func updated(_ action: @escaping (_ value: Value) -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            action(newValue)
        })
    }
}
