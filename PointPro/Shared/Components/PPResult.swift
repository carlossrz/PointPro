//
//  PPResult.swift
//  PointPro
//
//  Created by Carlos Suarez on 4/6/25.
//

import SwiftUI

struct PPResult: View {
    var pTeam1: Int
    var pTeam2: Int
    var number: Int

    var numberSet: String {
        switch number {
        case 0:
            return "one".localizedValue
        case 1:
            return "two".localizedValue
        case 2:
            return "three".localizedValue
        case 3:
            return "four".localizedValue
        case 4:
            return "five".localizedValue
        default:
            return "Otro número"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("set \(numberSet)")
                .foregroundStyle(.ppBlue)
                .font(.system(size: 15, weight: .light))
                .padding(.bottom, -14)
                .padding(.leading, 8)
            ZStack {
                Rectangle()
                    .fill(Color.ppBlue)
                    .frame(height: 60)
                    .cornerRadius(12)
                Text("\(pTeam1) - \(pTeam2)")
                    .foregroundStyle((pTeam1 > pTeam2) ? .ppGreenBall : .red)
                    .font(.system(size: 35, weight: .bold))
            }
        }
    }
}

#Preview {
    PPResult(pTeam1: 6, pTeam2: 4, number: 3)
}
