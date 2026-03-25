//
//  TieBreakView.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 11/7/25.
//

import SwiftUI

struct TieBreakView: View {
    @StateObject private var vm: TieBreakViewModel
    @Environment(\.dismiss) var dismiss
    var onDismiss: () -> Void
    
    init(matchData: MatchData, onDismiss: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: TieBreakViewModel(matchData: matchData))
        self.onDismiss = onDismiss
    }
    
    
    @State private var countdownFinished = false
    
    var body: some View {
        VStack {
            if countdownFinished == false {
                PPCountDown(initialCount: 5) { countdownFinished = true }
            } else {
                PointsButtons
            }
        }
        .backgroundGrid(backgroundVersion: .watchOS)
        .navigationBarBackButtonHidden(true)
        .onChange(of: vm.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
                onDismiss()
            }
        }
        
    }
    @ViewBuilder
    var PointsButtons: some View {
        VStack {
            ZStack{
                HStack(spacing:30){
                    PPCircleButton(points:  "\(vm.tieBreakPointsA)") {
                        vm.sumPoint(team: 1)
                    }
                    PPCircleButton(points: "\(vm.tieBreakPointsB)"){
                        vm.sumPoint(team: 2)
                    }
                }
                icons
                    .padding(.leading,!vm.matchData.isOpenSet ? -85 : 130)
                    .padding(.top,-35)
            }
        }
    }
    
    @ViewBuilder
    var icons: some View {
        ZStack{
            Circle()
                .frame(width: 25, height: 25)
                .foregroundStyle(.ppBlue)
            Text("🎾")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
        }
    }
    
    
}



#Preview {
    TieBreakView(matchData: MatchData()){}
}
