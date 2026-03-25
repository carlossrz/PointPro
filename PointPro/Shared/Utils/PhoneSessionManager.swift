//
//  WatchConnector.swift
//  PointPro
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import WatchConnectivity
import os

class PhoneSessionManager: NSObject, WCSessionDelegate {
    static let shared = PhoneSessionManager()
    private let logger = Logger(subsystem: "com.pointpro.phone", category: "PhoneSessionManager")

    override init() {
        super.init()
        logger.debug("PhoneSessionManager inicializado")
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleIncomingMatchData(from: message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        handleIncomingMatchData(from: userInfo)
    }

    // Método para decodificar y guardar el match
    private func handleIncomingMatchData(from dict: [String: Any]) {
        guard let data = dict["matchData"] as? Data else {
            logger.error("No se encontró matchData en el diccionario")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let codableMatch = try decoder.decode(MatchDataCodable.self, from: data)
            let match = codableMatch.asMatchData()
            logger.info("Match recibido correctamente: \(String(describing: match))")
            Task {
                // CRUDDataService.saveMatch is @MainActor; calling from Task will hop to main actor
                await CRUDDataService.shared.saveMatch(match)
            }
        } catch {
            logger.error("Error decodificando MatchData: \(error.localizedDescription, privacy: .public)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            logger.error("Error al activar sesión: \(error.localizedDescription, privacy: .public)")
        } else {
            logger.info("Sesión activada en iPhone.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        logger.info("Sesión WCSession inactiva temporalmente")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        logger.info("Sesión desactivada, reactivando...")
        WCSession.default.activate()
    }
}
