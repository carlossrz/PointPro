//
//  PPToggleOptions.swift
//  PointPro
//
//  Created by Carlos Suarez on 16/6/25.
//

import SwiftUI

struct PPToggleOptions<T: Equatable>: View {
    @Binding var value: T
    let firstValue: T
    let secondValue: T
    let firstLabel: String
    let secondLabel: String
    let firstColor: Color
    let secondColor: Color
    let title: String?
    
    var body: some View {
        VStack(spacing: 2) {
            if let title = title {
                Text(LocalizedStringKey(title))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading) 
            }
            
            Button(action: {
                value = (value == firstValue) ? secondValue : firstValue
            }) {
                Text(LocalizedStringKey(value == firstValue ? firstLabel : secondLabel))
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(value == firstValue ? firstColor : secondColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .animation(.easeInOut, value: value)
            }.buttonStyle(.plain)
        }
    }
}

#Preview {
    ZStack {
        PPToggleOptions(value: .constant(false),
                        firstValue: true,
                        secondValue: false,
                        firstLabel: "Option One",
                        secondLabel: "Option Two",
                        firstColor: .ppBlue,
                        secondColor: .ppGreenBall,
                        title: "luis")
    }
    
}
