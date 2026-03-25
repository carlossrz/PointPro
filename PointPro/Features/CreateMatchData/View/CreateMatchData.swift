//
//  CreateMatchData.swift
//  PointPro
//
//  Created by Carlos Suarez on 28/5/25.
//

import SwiftUI

struct CreateMatchData: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var newMatch : MatchData
    
    @State private var selectedGameMode: MatchFormat = .bo1
    
    @State private var team1Score = 0
    @State private var team2Score = 0
    
    @State private var isPresented: Bool = false
    
    let scoreOptions = Array(0...7)
    
    var body: some View {
        ScrollView {
            PPSectionCard(title: "text.detailsMacthes".localizedValue) {
                VStack(spacing: 20) {
                    TextField("text.location",text: Binding(
                        get: { newMatch.location ?? "" },
                        set: { newMatch.location = $0 }
                    ))
                    TextField("text.teammate",text: Binding(
                        get: { newMatch.teammates ?? "" },
                        set: { newMatch.teammates = $0 }
                    ))
                    DatePicker("text.date", selection: $newMatch.date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }.padding(.horizontal)
                .padding(.top,40)
            
            PPSectionCard(title: "") {
                HStack{
                    PPToggleOptions(
                        value: $newMatch.position,
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
                        value: $newMatch.isOpenSet,
                        firstValue: true,
                        secondValue: false,
                        firstLabel: "text.openning",
                        secondLabel: "text.receiving",
                        firstColor: .ppBlue,
                        secondColor: .ppBlue,
                        title: "info.openset"
                    )
                }
            }.padding(.horizontal)
            PPSectionCard(title: "info.pointsInGame".localizedValue) {
                VStack(spacing: 20){
                    Picker("info.pointsInGame", selection: $newMatch.pointType) {
                        ForEach(MatchFormat.allCases) { game in
                            Text(game.rawValue).tag(game)
                        }
                    }.pickerStyle(.palette)
                    if newMatch.games.count < newMatch.pointType.numberOfGames {
                        VStack {
                            VStack {
                                Picker("", selection: $team1Score) {
                                    ForEach(scoreOptions, id: \.self) { score in
                                        Text("\(score)")
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: .infinity)
                                
                                Picker("", selection: $team2Score) {
                                    ForEach(scoreOptions, id: \.self) { score in
                                        Text("\(score)")
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: .infinity)
                            }.frame(height: 80)
                            PPButton(text: "text.addset") {
                                let order = newMatch.games.count
                                let newGame = GameScore(team1: team1Score,
                                                        team2: team2Score,
                                                        order: order)
                                newMatch.games.append(newGame)
                                team1Score = 0
                                team2Score = 0
                            }
                        }
                    }
                    if newMatch.games.count > 0 {
                        PPResultsCardView(match: newMatch)
                    }
                }
            }.padding(.horizontal)
            PPButtonSlider(text:"save.match") {
                if ((newMatch.teammates?.isEmpty) != nil) || ((newMatch.location?.isEmpty) != nil) {
                    context.insert(newMatch)
                    try? context.save()
                    dismiss()
                } else {
                    isPresented.toggle()
                }
            }
            .alert("key.attention",
                   isPresented: $isPresented,
                   actions: {
                Button("OK") {}},
                   message: {
                Text("text.completedFields")
            })
            .frame(height: 60)
        }.backgroundGrid(color:.ppGreenBall,backgroundVersion: .iOS)
            
    }
}

#Preview {
    CreateMatchData(newMatch: .constant(MatchData()))
}
