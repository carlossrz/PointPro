//
//  StadisticsView.swift
//  PointPro
//
//  Created by Carlos Suarez on 17/6/25.
//

import SwiftUI
import SwiftData

struct StadisticsView: View {
    @Query(sort: \MatchData.date,order: .reverse) private var matches: [MatchData]
    @StateObject private var vm: StatisticsViewModel
    
    init() {
        _vm = StateObject(wrappedValue: StatisticsViewModel(matches: []))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading,spacing:10) {
                    Text("text.stadistics".localizedValue)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.ppBlue)

                    // Small 4-card panel
                    HStack(spacing: 12) {
                        SmallStatCard(title: "Partidos", value: "\(vm.totalMatches)")
                        SmallStatCard(title: "Sets/match", value: String(format: "%.1f", vm.averageSetsPerMatch))
                        SmallStatCard(title: "Tie-break", value: "\(Int(vm.tieBreakFrequency * 100))%")
                        SmallStatCard(title: "Racha", value: "\(vm.currentWinStreak)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)

                    PPSectionCard(title: "",
                                  color: Color(.lightGray).opacity(0.1)){
                        VStack {
                            PPProgressRingView(progress: vm.winPercentage)
                                .frame(height: 200)
                                .padding(.bottom, 10)

                            HStack(spacing: 60) {
                                VStack {
                                    Text("\(vm.wonMatches)")
                                        .font(.system(size: 30, weight: .bold))
                                    Text("text.wins")
                                        .font(.system(size: 10, weight: .light))
                                }.foregroundStyle(.ppBlue)
                                
                                VStack {
                                    Text("\(vm.lostMatches)")
                                        .font(.system(size: 30, weight: .bold))
                                    Text("text.losses")
                                        .font(.system(size: 10, weight: .light))
                                }.foregroundStyle(.ppBlue)
                                
                                VStack {
                                    Text("\(vm.drawMatches)")
                                        .font(.system(size: 30, weight: .bold))
                                    Text("text.draws")
                                        .font(.system(size: 10, weight: .light))
                                }.foregroundStyle(.ppBlue)
                            }.frame(maxWidth: .infinity)
                        }.padding(.vertical)
                    }
                    PPSectionCard(title: "text.performSide".localizedValue,
                                  color: Color(.lightGray).opacity(0.1)){
                        SidePerformanceChart(data: vm.sideStats)
                    }
                    
                    HStack(spacing: 20) {
                        PPSectionCard(title: "text.winsOpening".localizedValue,
                                      color: Color(.lightGray).opacity(0.1)){
                            PPProgressRingView(actual: vm.wonMatchesWhenOpening,
                                               total: vm.totalMatchesWhenOpening)
                            .frame(height: 130)
                        }
                        PPSectionCard(title: "text.winsReceiving".localizedValue,
                                      color: Color(.lightGray).opacity(0.1)){
                            PPProgressRingView(actual: vm.wonMatchesWhenReceiving,
                                               total: vm.totalMatchesWhenReceiving)
                            .frame(height: 130)
                        }
                    }
                    
                    PPSectionCard(title: "text.latestMatches".localizedValue,
                                  color: Color(.lightGray).opacity(0.1)){
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(vm.lastThreeMatches, id: \.id) { match in
                                PPMatchCell(matchData: match, cellType: .simple)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }.padding(.top,20)
                 .padding(.horizontal,15)
            }
        }
        .onAppear {
            vm.updateMatches(with: matches)
        }
    }
    
}

#Preview {
    StadisticsView()
}

// Small card view used by StadisticsView
fileprivate struct SmallStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.ppBlue)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}
