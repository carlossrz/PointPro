//
//  PointWatchApp.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 28/4/25.
//

import SwiftUI

@main
struct PointWatch_Watch_AppApp: App {
    init() {
        // Ensure WCSession is configured early
        _ = WatchSessionManager.shared
    }
    var body: some Scene {
        WindowGroup {
            StartMatchView()
        }
    }
}
