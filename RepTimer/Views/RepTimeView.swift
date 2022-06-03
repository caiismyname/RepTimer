//
//  RepTimeView.swift
//  RepTimer
//
//  Created by David Cai on 5/30/22.
//

import Foundation
import SwiftUI


struct RepTimeView: View {
    @StateObject var rep: Rep

  var body: some View {
      VStack {
          Text(rep.repDurationFormatted())
              .font(.title)
              .minimumScaleFactor(1.0)
          Button(action: {rep.restart()}) {
              Text("Reset")
          }
      }
  }
}

struct RepTimeView_Previews: PreviewProvider {
  static var previews: some View {
    let rep = Rep()
    Group {
        RepTimeView(rep: rep)
    }
  }
}

