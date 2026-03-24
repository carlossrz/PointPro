//
//  ScoreBoardView.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 30/4/25.
//

import SwiftUI
import os

struct ScoreBoardView: View {
    private let logger = Logger(subsystem: "com.pointpro.watch", category: "ScoreBoardView")
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ScoreboardViewModel()
    
    var matchData = MatchData()
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            TabView {
                scoreboardContent
                SettingsView
            }.tabViewStyle(.carousel)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            vm.restPoint()
                        } label: {
                            Image(systemName:"arrow.counterclockwise")
                                .foregroundStyle(.red)
                        }
                    }
                }.padding(.top,-25)
        }.backgroundGrid(backgroundVersion: .watchOS)
    }

    @ViewBuilder
    var SettingsView: some View {
        PPButton(text: "finish.match",color:.ppGreenBall){
            // Give immediate haptic feedback on the Watch
            WKInterfaceDevice.current().play(.success)
            // Send match data to phone/watch connectivity
            vm.saveData()
            // Dismiss view and mark as finished
            onDismiss()
            vm.shouldDismiss = true
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    var scoreboardContent: some View {
        VStack(spacing:20){
            HStack{
                PPScoreBoard(isOpenSet: vm.matchData.isOpenSet,
                             globalPointsMatch: vm.matchData.games,
                             liveGameScores: vm.liveGameScores)
                Spacer()
                
            }
            PointsButtons
        }.padding()
        .onAppear(perform: {
            vm.matchData = matchData
        })
        .onChange(of: vm.shouldDismiss) { _, newValue in
            if newValue {
                vm.clearData()
                vm.resetPoints()
                vm.matchData = MatchData()
                dismiss()
                onDismiss()
            }
        }.navigationDestination(isPresented: $vm.isTieBreak) {
            TieBreakView(matchData: vm.matchData ){
                if matchData.pointType.numberOfGames == matchData.games.count {
                    logger.info("Partido finalizado: \(vm.matchData.finalScore)")
                    vm.saveData()
                    onDismiss()
                    vm.shouldDismiss = true
                }
            }
        }
    }
    
    @ViewBuilder
    var PointsButtons: some View {
        HStack(spacing:30){
            PPCircleButton(points: vm.pointA) {
                vm.team = 1
                vm.sumPoint()
            }
            PPCircleButton(points: vm.pointB){
                vm.team = 2
                vm.sumPoint()
            }
        }
    }
}

#Preview {
    ScoreBoardView(){}
}
