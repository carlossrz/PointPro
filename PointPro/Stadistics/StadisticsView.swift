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
                    PPSectionCard(title: ""){
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
                    PPSectionCard(title: "text.performSide".localizedValue){
                        SidePerformanceChart(data: vm.sideStats)
                    }
                    
                    HStack(spacing: 20) {
                        PPSectionCard(title: "text.winsOpening".localizedValue) {
                            PPProgressRingView(actual: vm.wonMatchesWhenOpening,
                                               total: vm.totalMatchesWhenOpening)
                            .frame(height: 130)
                        }
                        PPSectionCard(title: "text.winsReceiving".localizedValue) {
                            PPProgressRingView(actual: vm.wonMatchesWhenReceiving,
                                               total: vm.totalMatchesWhenReceiving)
                            .frame(height: 130)
                        }
                    }
                    
                    PPSectionCard(title: "text.latestMatches".localizedValue) {
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







