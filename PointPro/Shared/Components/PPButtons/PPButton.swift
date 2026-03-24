//
//  PPButton.swift
//  PointPro
//
//  Created by Carlos Suarez on 5/6/25.
//

import SwiftUI

struct PPButton: View {
    var text: String = "ok"
    var color: Color = .ppBlue
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
        }label: {
            HStack {
                ZStack{
                    Text(text.localizedValue)
                        .font(.system(size: 20, weight: .light))
                        .padding(.horizontal, 10)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(color)
                .clipShape(.capsule)
            }
        }.buttonStyle(.plain)
        
    }
}

#Preview {
    PPButton()
}
