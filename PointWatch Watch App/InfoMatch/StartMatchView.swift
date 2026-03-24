//
//  InfoMacthviEW.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 6/5/25.
//

import SwiftUI

struct StartMatchView: View {
    
    @State var isStart: Bool = false
    @State var shouldNavigate = false
    @State var matchData = MatchData()
    @ObservedObject private var settings = WatchSettingsService.shared
    
    @State private var expanded = false

    let screenSize = WKInterfaceDevice.current().screenBounds.size

    var body: some View {
        ZStack {
            if isStart {
                InfoMatchData
            } else {
                ZStack {
                    Circle()
                        .fill(Color.ppGreenBall)
                        .frame(width: 150, height: 150)
                        .scaleEffect(expanded ? screenSize.height / 150 * 2 : 1)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                        .overlay(
                            Text("text.configureMatch")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(expanded ? 0 : 1)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                expanded = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                isStart = true
                            }
                        }
                }
                .frame(width: screenSize.width, height: screenSize.height)
                .backgroundGrid(backgroundVersion: .watchOS)
            }
        }
        .frame(width: screenSize.width, height: screenSize.height)
        .ignoresSafeArea()
        .onAppear {
            // Initialize defaults from WatchSettingsService
            matchData.position = WatchSettingsService.shared.defaultPosition
            matchData.pointType = WatchSettingsService.shared.defaultMatchFormat
        }
        .onChange(of: settings.defaultPositionRaw) { _, newValue in
            matchData.position = settings.defaultPosition
        }
        .onChange(of: settings.defaultMatchFormatRaw) { _, newValue in
            matchData.pointType = settings.defaultMatchFormat
        }
    }
    
    @ViewBuilder
    var InfoMatchData: some View {
        NavigationStack {
            TabView {
                VStack(alignment:.leading, spacing:10) {
                    Text("info.match.title")
                        .font(.system(size: 20))
                        .foregroundStyle(.ppBlue)
                    PPToggleOptions(
                        value: $matchData.isOpenSet,
                        firstValue: true,
                        secondValue: false,
                        firstLabel: "text.openning",
                        secondLabel: "text.receiving",
                        firstColor: .ppBlue,
                        secondColor: .ppBlue,
                        title: "info.openset"
                    )
                    PPToggleOptions(
                        value: $matchData.position,
                        firstValue: PlayerSide.right,
                        secondValue: PlayerSide.left,
                        firstLabel:  PlayerSide.right.localized,
                        secondLabel: PlayerSide.left.localized,
                        firstColor: .ppBlue,
                        secondColor: .ppBlue,
                        title: "text.selectposition"
                    )
                }
                .padding(.top,-20)
                VStack(alignment:.leading, spacing:10){
                    Picker("", selection: $matchData.pointType) {
                        ForEach(MatchFormat.allCases) { game in
                            Text(game.rawValue).tag(game)
                        }
                    }.frame(height: 80)
                    PPButtonSlider {
                        shouldNavigate.toggle()
                    }.frame(height: 50)
                }
                .padding(.top,-20)
            }
            .tabViewStyle(.page)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $shouldNavigate) {
                ScoreBoardView(matchData: matchData) {
                    withAnimation(.easeInOut) {
                        isStart = false
                        expanded = false
                        matchData = MatchData()
                    }
                }
            }
        }
    }
}


#Preview {
    StartMatchView()
}
