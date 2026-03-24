//
//  PointProApp.swift
//  PointPro
//
//  Created by Carlos Suarez on 24/4/25.
//

import SwiftUI
import SwiftData

@main
struct PointProApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MatchData.self,
            GameScore.self
        ])
        let config = ModelConfiguration("PointProBBDD", schema: schema, isStoredInMemoryOnly:false)
        
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            do {
                return try ModelContainer(
                    for: schema,
                    configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)]
                )
            } catch {
                fatalError("❌ Preview failed to load container: \(error)")
            }
        }
#endif

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("❌ Failed to load main container: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState.shared)
                .environmentObject(SettingsService.shared)
                .task {
                    // Configure CRUD service early with the main context
                    CRUDDataService.shared.configure(sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
