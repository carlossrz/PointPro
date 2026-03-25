//
//  ContentView.swift
//  PointPro
//
//  Created by Carlos Suarez on 24/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var matches: [MatchData]
    @EnvironmentObject private var appState: AppState
    @State private var selectedMatch: MatchData? = nil

    var body: some View {
        TabView {
            MatchListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("text.matchList")
                }
            StadisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("text.stadistics")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("text.settings")
                }
        }
        .onAppear {
            CRUDDataService.shared.configure(modelContext)
        }
        .onChange(of: appState.selectedMatchId) { _, newValue in
            guard let idString = newValue, let uuid = UUID(uuidString: idString) else { return }
            // fetch MatchData by id
            let fetch = FetchDescriptor<MatchData>(predicate: #Predicate { $0.id == uuid })
            if let found = try? modelContext.fetch(fetch).first {
                selectedMatch = found
            }
        }
        .sheet(item: $selectedMatch) { match in
            MatchDetailView(match: .constant(match))
        }
    }
}

#Preview {
    // Preview with an in-memory ModelContainer to avoid touching on-disk DB
    let schema = Schema([MatchData.self, GameScore.self])
    let container: ModelContainer = {
        do {
            return try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
        } catch {
            fatalError("Failed to create in-memory ModelContainer for preview: \(error)")
        }
    }()

    ContentView()
        .modelContainer(container)
}
