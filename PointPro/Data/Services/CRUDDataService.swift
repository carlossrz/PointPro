//
//  CRUDDataService.swift
//  PointPro
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import SwiftData
import os
import UserNotifications

@MainActor
final class CRUDDataService {
    static let shared = CRUDDataService()
    var modelContext: ModelContext?
    private var pendingMatches: [MatchData] = []
    private let logger = Logger(subsystem: "com.pointpro.crud", category: "CRUDDataService")

    private var pendingDirectory: URL? = {
        let fm = FileManager.default
        do {
            let appSupport = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dir = appSupport.appendingPathComponent("PointProPendingMatches", isDirectory: true)
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
            return dir
        } catch {
            return nil
        }
    }()

    func configure(_ ctx: ModelContext) {
        self.modelContext = ctx
        // Flush any in-memory pending matches
        if !pendingMatches.isEmpty {
            logger.info("Flushing \(self.pendingMatches.count) pending matches to DB")
            for match in pendingMatches {
                Task { await saveMatch(match) }
            }
            pendingMatches.removeAll()
        }

        // Load and flush any disk-backed pending matches
        if let dir = pendingDirectory {
            do {
                let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
                for file in files {
                    do {
                        let data = try Data(contentsOf: file)
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let codable = try decoder.decode(MatchDataCodable.self, from: data)
                        let match = codable.asMatchData()
                        Task { await saveMatch(match) }
                        try FileManager.default.removeItem(at: file)
                        logger.info("Flushed pending match from disk: \(file.lastPathComponent)")
                    } catch {
                        logger.error("Failed to flush pending file \(file.lastPathComponent): \(error.localizedDescription, privacy: .public)")
                    }
                }
            } catch {
                logger.error("Failed to read pending matches directory: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    func saveMatch(_ match: MatchData) async {
        guard let ctx = modelContext else {
            logger.warning("ModelContext not configured; buffering match for later save")
            pendingMatches.append(match)
            // Persist to disk as a fallback
            persistPendingMatchToDisk(match)
            return
        }
        ctx.insert(match)
        do {
            try ctx.save()
            // Notify user that a match was saved
            deliverMatchSavedNotification(match: match)
        } catch {
            logger.error("Failed to save match: \(error.localizedDescription, privacy: .public)")
            // As fallback, persist to disk
            persistPendingMatchToDisk(match)
        }
    }

    func deleteMatch(_ match: MatchData) {
        guard let ctx = modelContext else {
            logger.error("ModelContext not configured; cannot delete match")
            return
        }
        ctx.delete(match)
        do {
            try ctx.save()
        } catch {
            logger.error("Failed to delete match: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Disk persistence for pending matches
    private func persistPendingMatchToDisk(_ match: MatchData) {
        guard let dir = pendingDirectory else {
            logger.error("No pending directory available; cannot persist pending match")
            return
        }
        let codable = match.asCodable()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(codable)
            let filename = UUID().uuidString + ".json"
            let url = dir.appendingPathComponent(filename)
            try data.write(to: url, options: .atomic)
            logger.info("Persisted pending match to disk: \(filename)")
        } catch {
            logger.error("Failed to persist pending match to disk: \(error.localizedDescription, privacy: .public)")
        }
    }

    // MARK: - Local Notification
    private func deliverMatchSavedNotification(match: MatchData) {
        let content = UNMutableNotificationContent()
        content.title = "Partido guardado"
        content.body = "Tu partido ha sido guardado. Pulsa para ver estadísticas."
        content.sound = .default

        // Optionally add match id as userInfo to open specific view
        content.userInfo = ["matchId": match.id.uuidString]

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.logger.error("Failed to schedule notification: \(error.localizedDescription, privacy: .public)")
            } else {
                self.logger.info("Match saved notification scheduled")
            }
        }
    }
}
