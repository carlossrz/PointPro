import Foundation
import SwiftUI
import WatchConnectivity
import os

@MainActor
final class SettingsService: ObservableObject {
    static let shared = SettingsService()

    // Keys
    @AppStorage("pp.enableNotifications") var enableNotifications: Bool = true
    @AppStorage("pp.autoSendOnFinish") var autoSendOnFinish: Bool = true
    @AppStorage("pp.savePartialOnFinish") var savePartialOnFinish: Bool = true
    @AppStorage("pp.hapticOnFinish") var hapticOnFinish: Bool = true
    @AppStorage("pp.defaultMatchFormat") var defaultMatchFormatRaw: String = "Best of One"
    @AppStorage("pp.defaultPosition") var defaultPositionRaw: String = "right"
    @AppStorage("pp.accentColor") var accentColorName: String = "PPBlue"

    var defaultMatchFormat: MatchFormat {
        MatchFormat(rawValue: defaultMatchFormatRaw) ?? .bo1
    }

    var defaultPosition: PlayerSide {
        PlayerSide(rawValue: defaultPositionRaw) ?? .right
    }

    var accentColor: Color {
        // Map stored asset name to Color asset; fallback to PPBlue
        return Color(accentColorName)
    }

    // Available accent color options (should match Asset Catalog names)
    let accentOptions: [String] = ["PPBlue", "PPBeige", "PPGreenBall"]

    private init() {}

    // MARK: - Sync to Watch
    func syncToWatch() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        let logger = Logger(subsystem: "com.pointpro.phone", category: "SettingsService")

        logger.info("syncToWatch: session activationState=\(session.activationState.rawValue)")
        logger.info("syncToWatch: isPaired=\(session.isPaired.description), isWatchAppInstalled=\(session.isWatchAppInstalled.description), isReachable=\(session.isReachable.description)")

        let payload: [String: Any] = [
            "settings": [
                "defaultMatchFormat": defaultMatchFormatRaw,
                "defaultPosition": defaultPositionRaw,
                "accentColor": accentColorName,
                "autoSendOnFinish": autoSendOnFinish,
                "savePartialOnFinish": savePartialOnFinish,
                "hapticOnFinish": hapticOnFinish,
                "enableNotifications": enableNotifications
            ]
        ]

        if session.isReachable {
            logger.info("sendMessage: sending settings via sendMessage")
            session.sendMessage(payload, replyHandler: { resp in
                logger.info("sendMessage reply: \(String(describing: resp))")
            }, errorHandler: { error in
                logger.error("sendMessage failed: \(error.localizedDescription, privacy: .public)")
            })
        } else {
            logger.info("sendMessage: session not reachable, using transferUserInfo")
            let transfer = session.transferUserInfo(payload)
            logger.info("transferUserInfo enqueued: \(transfer.debugDescription)" )
        }
    }
}
