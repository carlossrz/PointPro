//
//  MatchDetailView.swift
//  PointPro
//
//  Created by Carlos Suarez on 27/5/25.
//

import SwiftUI
struct MatchDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var match : MatchData
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(match.finalScore)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(match.isWinner ? .ppGreenBall : .red)
                    
                    Text(match.date.shortFormatted)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                PPSectionCard(title: "text.detailsMacthes".localizedValue) {
                    VStack(alignment: .leading, spacing: 22) {
                        TextField("text.location", text: Binding(
                            get: { match.location ?? "" },
                            set: { match.location = $0 }
                        ))
                        TextField("text.teammate", text: Binding(
                            get: { match.teammates ?? "" },
                            set: { match.teammates = $0 }
                        ))
                    }
                }
                PPSectionCard(title: "") {
                    HStack(spacing:20){
                        PPToggleOptions(
                            value: $match.position,
                            firstValue: PlayerSide.left,
                            secondValue: PlayerSide.right,
                            firstLabel:  PlayerSide.left.localized,
                            secondLabel: PlayerSide.right.localized,
                            firstColor: .ppBlue,
                            secondColor: .ppBlue,
                            title: "text.selectposition"
                        )
                        Spacer()
                        PPToggleOptions(
                            value: $match.isOpenSet,
                            firstValue: true,
                            secondValue: false,
                            firstLabel: "text.openning",
                            secondLabel: "text.receiving",
                            firstColor: .ppBlue,
                            secondColor: .ppBlue,
                            title: "info.openset"
                        )
                    }
                }
                PPSectionCard(title: "text.results".localizedValue.uppercased()) {
                    PPResultsCardView(match: match)
                }
            }.padding(.horizontal)
        }.backgroundGrid(backgroundVersion:.iOS)
         .contentMargins(.top,30)
    }
}

#Preview {
    MatchDetailView(match: .constant(MatchData(id: UUID(),
                                               teammates: "",
                                               date: Date(),
                                               location: "",
                                               games: [(GameScore(team1: 6, team2: 0, order: 0)),
                                                       (GameScore(team1: 2, team2: 6, order: 1)),
                                                       (GameScore(team1: 6, team2: 5, order: 2))],
                                               pointType: .bo3,
                                               isOpenSet: false ,
                                               position: .right)))
}
