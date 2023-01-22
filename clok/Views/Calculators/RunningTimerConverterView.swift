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
    @State var editingBasisTime = false
    @State var editingDisplayedDistances = false
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            Button(action: {
                editingDisplayedDistances = !editingDisplayedDistances
            }) {
                Text(editingDisplayedDistances ? "Done" : "Edit")
                    .font(.system(size: Sizes.calculatorFontSize))
            }
            
            Text("Running Paces").font(.system(size: 25, weight: .heavy , design: .monospaced))
                .padding([.leading, .trailing, .top])
            
            Spacer()
            
            if !editingBasisTime {
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        List(
                            model.distances.indices.filter({ index in
                                // Only show selected distances normally, or all distances if editing
                                return editingDisplayedDistances || model.distances[index].selected
                            }),
                            id: \.self
                        ){ index in
                            RunningPaceCalculatorRow(
                                distance: model.distances[index],
                                basisDistance: model.basisDistance,
                                editingDisplayedDistances: editingDisplayedDistances
                            )
                                .onTapGesture {
                                    if editingDisplayedDistances {
                                        model.distances[index].selected = !model.distances[index].selected
                                    } else {
                                        editingBasisTime = true
                                        model.keyboardModel.value = model.distances[index].time
                                        model.changeBasis(newBasis: model.distances[index])
                                    }
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
                            editingBasisTime = false
                        }) {
                            Text("Cancel")
                                .font(.system(size: Sizes.calculatorFontSize, weight: .regular , design: .monospaced))
                                .frame(maxWidth: .infinity, maxHeight: Sizes.inputHeight)
                        }
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(12)
                        Button(action: {
                            haptic.impactOccurred()
                            model.changeBasisTime(newTime: model.keyboardModel.value)
                            model.recomputeAll()
                            editingBasisTime = false
                        }) {
                            Text("Done")
                                .font(.system(size: Sizes.calculatorFontSize, weight: .heavy , design: .monospaced))
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

struct RunningPaceCalculatorRow: View {
    @ObservedObject var distance: RunningDistance
    @ObservedObject var basisDistance: RunningDistance
    var editingDisplayedDistances: Bool
    
    var body: some View {
        HStack {
            if editingDisplayedDistances {
                ZStack {
                    if distance.selected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.blue)
                            .font(.system(size: Sizes.calculatorFontSize))
                    } else {
                        Circle().strokeBorder(Color.white)
                    }
                }
                    .frame(width:Sizes.calculatorFontSize, height: Sizes.calculatorFontSize)
            }
            Text("\(distance.name)")
                .font(.system(size: Sizes.calculatorFontSize, weight: .bold , design: .monospaced))
                .foregroundColor(distance.distanceInMeters == basisDistance.distanceInMeters ? Color.blue : Color.white)
            Spacer()
            Text("\(distance.time.formattedTimeNoMilliNoLeadingZero)")
                .font(.system(size: Sizes.calculatorFontSize, weight: .regular , design: .monospaced))
                .foregroundColor(distance.distanceInMeters == basisDistance.distanceInMeters ? Color.blue : Color.white)
        }
        .minimumScaleFactor(0.01)
        .frame(minWidth: 0, minHeight: 0, alignment: .center)
        .contentShape(Rectangle())
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

