//
//  ConnectorMobile.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import WatchConnectivity
import os

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let shared = WatchSessionManager()
    private let logger = Logger(subsystem: "com.pointpro.watch", category: "WatchSessionManager")
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            logger.error("Activación fallida: \(error.localizedDescription, privacy: .public)")
        } else {
            logger.info("Sesión activada con estado: \(activationState.rawValue)")
        }
    }

    //Envio en tiempo real
    func sendMessageMatchResult(match: MatchData) {
        logger.debug("Intentando enviar match con sendMessage")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(match.asCodable())
            let message: [String: Any] = ["matchData": data]

            if WCSession.default.isReachable {
                logger.info("iPhone alcanzable. Enviando datos...")
                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                    self.logger.error("Error en sendMessage: \(error.localizedDescription, privacy: .public)")
                }
            } else {
                logger.warning("iPhone no está alcanzable. No se pudo enviar el mensaje.")
            }

        } catch {
            logger.error("Error codificando MatchData: \(error.localizedDescription, privacy: .public)")
        }
    }

    //Envio en background
    func sendMatchResult(match: MatchData) {
        let session = WCSession.default
        logger.debug("Intentando enviar match con transferUserInfo")

        guard session.activationState == .activated else {
            logger.error("Sesión no activada en Watch")
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(match.asCodable())
            session.transferUserInfo(["matchData": data])
            logger.info("Match transferUserInfo encolado")
        } catch {
            logger.error("Error codificando MatchData para transferUserInfo: \(error.localizedDescription, privacy: .public)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Check if it's settings payload
        if let settingsDict = message["settings"] as? [String: Any] {
            // Update watch local settings on main actor
            Task {
                await MainActor.run {
                    if let format = settingsDict["defaultMatchFormat"] as? String {
                        WatchSettingsService.shared.defaultMatchFormatRaw = format
                    }
                    if let pos = settingsDict["defaultPosition"] as? String {
                        WatchSettingsService.shared.defaultPositionRaw = pos
                    }
                    if let accent = settingsDict["accentColor"] as? String {
                        WatchSettingsService.shared.accentColorName = accent
                    }
                }
            }
            logger.info("Settings received from iPhone and stored on Watch")
            return
        }

        // existing matchData handling could go here if used on watch, but Watch side primarily sends
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // Also implement message receipt with reply handler
        if let settingsDict = message["settings"] as? [String: Any] {
            // Update watch local settings on main actor
            Task {
                await MainActor.run {
                    if let format = settingsDict["defaultMatchFormat"] as? String {
                        WatchSettingsService.shared.defaultMatchFormatRaw = format
                    }
                    if let pos = settingsDict["defaultPosition"] as? String {
                        WatchSettingsService.shared.defaultPositionRaw = pos
                    }
                    if let accent = settingsDict["accentColor"] as? String {
                        WatchSettingsService.shared.accentColorName = accent
                    }
                }
            }
            logger.info("Settings received from iPhone (replyHandler) and stored on Watch")
            replyHandler(["status": "ok"])
            return
        }

        // Default reply
        replyHandler([:])
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        // Also handle background userInfo deliveries for settings
        if let settingsDict = userInfo["settings"] as? [String: Any] {
            Task {
                await MainActor.run {
                    if let format = settingsDict["defaultMatchFormat"] as? String {
                        WatchSettingsService.shared.defaultMatchFormatRaw = format
                    }
                    if let pos = settingsDict["defaultPosition"] as? String {
                        WatchSettingsService.shared.defaultPositionRaw = pos
                    }
                    if let accent = settingsDict["accentColor"] as? String {
                        WatchSettingsService.shared.accentColorName = accent
                    }
                }
            }
            logger.info("Settings received via userInfo and stored on Watch")
            return
        }
    }

}
