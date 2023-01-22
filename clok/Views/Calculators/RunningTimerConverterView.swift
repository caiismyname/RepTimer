//
//  RunningTimerConverterView.swift
//  RepTimer
//
//  Created by David Cai on 1/21/23.
//

import Foundation
import SwiftUI

struct RunningTimeConverterView: View {
    @ObservedObject var model = RunningTimeConverterModel()
    @State var editing = false
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    editing = !editing
                }) {Image(systemName: "gearshape.circle")}
                Spacer()
                Text("Running Paces")
                    .font(.system(size: 25, weight: .heavy , design: .monospaced))
                Spacer()
            }
                .font(.system(size: Sizes.inputIconSize))
                .padding([.leading, .trailing, .top])
            
            Spacer()
            
            if !editing {
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        List(model.distances.indices, id: \.self) { index in
                            HStack {
                                Text("\(model.distances[index].name)")
                                    .font(.system(size: 20, weight: .bold , design: .monospaced))
                                    .foregroundColor(model.distances[index].distanceInMeters == model.basisDistance.distanceInMeters ? Color.blue : Color.white)
                                Spacer()
                                Text("\(model.distances[index].time.formattedTimeNoMilliNoLeadingZero)")
                                    .font(.system(size: 20, weight: .regular , design: .monospaced))
                                    .foregroundColor(model.distances[index].distanceInMeters == model.basisDistance.distanceInMeters ? Color.blue : Color.white)
                            }
                            .minimumScaleFactor(0.01)
                            .frame(minWidth: 0, minHeight: 0, alignment: .center)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editing = true
                                model.keyboardModel.value = model.distances[index].time
                                model.changeBasis(newBasis: model.distances[index])
                            }
                        }
                        .listStyle(.plain)
                        .frame(width: geo.size.width * 0.7)
                        Spacer()
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("\(model.basisDistance.name) time")
                    CalculatorTimeInputView(keyboard: model.keyboardModel)
                    TimeInputKeyboardView(model: model.keyboardModel)
                    HStack {
                        Button(action: {
                            editing = false
                        }) {
                            Text("Cancel")
                                .font(.system(size: 20, weight: .regular , design: .monospaced))
                                .frame(maxWidth: .infinity, maxHeight: Sizes.inputHeight)
                        }
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(12)
                        Button(action: {
                            haptic.impactOccurred()
                            model.changeBasisTime(newTime: model.keyboardModel.value)
                            model.recomputeAll()
                            editing = false
                        }) {
                            Text("Done")
                                .font(.system(size: 20, weight: .heavy , design: .monospaced))
                                .frame(maxWidth: .infinity, maxHeight: Sizes.inputHeight)
                        }
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                        .padding([.top, .bottom])
                }
            }
        }
    }
}

struct CalculatorTimeInputView: View {
    @ObservedObject var keyboard: TimeInputKeyboardModel
    
    var body: some View {
        Text(keyboard.value.formattedTimeNoMilliNoLeadingZero)
            .font(Font.monospaced(.system(size: Sizes.bigTimeFont))())
            .minimumScaleFactor(0.1)
            .lineLimit(1)
    }
}

struct RunningTimeConverter_Previews: PreviewProvider {
    static var previews: some View {
        RunningTimeConverterView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
    }
}

