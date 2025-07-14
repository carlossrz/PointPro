//
//  WatchConnector.swift
//  PointPro
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import WatchConnectivity

class PhoneSessionManager: NSObject, WCSessionDelegate {
    static let shared = PhoneSessionManager()
    
    override init() {
        super.init()
        print("📱 PhoneSessionManager inicializado")
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
            print("❌ No se encontró matchData en el diccionario")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let codableMatch = try decoder.decode(MatchDataCodable.self, from: data)
            let match = codableMatch.asMatchData()
            print("✅ Match recibido correctamente: \(match)")
            Task {
                await CRUDDataService.shared.saveMatch(match)
            }
        } catch {
            print("❌ Error decodificando MatchData: \(error)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ Error al activar sesión: \(error.localizedDescription)")
        } else {
            print("✅ Sesión activada en iPhone.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("ℹ️ Sesión WCSession inactiva temporalmente")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("🔄 Sesión desactivada, reactivando...")
        WCSession.default.activate()
    }
}
