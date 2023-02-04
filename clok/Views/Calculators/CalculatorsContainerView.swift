//
//  CalculatorsContainerView.swift
//  RepTimer
//
//  Created by David Cai on 1/22/23.
//

import Foundation
import SwiftUI

enum CalculatorTypes {
    case none
    case runningPace
}

struct CalculatorsContainerView: View {
    @State var selectedCalculator = CalculatorTypes.none
    
    var body: some View {
        GeometryReader { geo in
            switch selectedCalculator {
            case .none:
                HStack {
                    Spacer()
                    VStack {
                        Text("Calculators")
                            .font(.system(size: 25, weight: .heavy))
                        CalculatorSelectionListEntry(title: "Running Pace", description: "Convert paces across distances")
                            .onTapGesture { selectedCalculator = .runningPace }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .frame(width: geo.size.width * 0.8)
            case .runningPace:
                RunningTimeConverterView()
            }
        }
    }
}

struct CalculatorSelectionListEntry: View {
    let title: String
    let description: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Sizes.radius)
                .stroke(Color.white, lineWidth: 2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: Sizes.calculatorFontSize, weight: .bold))
                Text(description)
                    .font(.system(size: Sizes.calculatorFontSize * 0.6, weight: .regular))
            }
            .padding()
            
        }
        .frame(height: 75)
    }
}


struct CalculatorList_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorsContainerView()
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 Pro")
    }
}


