//
//  ConnectorMobile.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    static let shared = WatchSessionManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("❌ Activación fallida: \(error.localizedDescription)")
        } else {
            print("✅ Sesión activada con estado: \(activationState.rawValue)")
        }
    }

    //Envio en tiempo real
    func sendMessageMatchResult(match: MatchData) {
        print("➡️ Intentando enviar match con sendMessage")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(match.asCodable())
            let message: [String: Any] = ["matchData": data]

            if WCSession.default.isReachable {
                print("iPhone alcanzable. Enviando datos...")
                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                    print("❌ Error en sendMessage:", error)
                }
            } else {
                print("⚠️ iPhone no está alcanzable. No se pudo enviar el mensaje.")
            }

        } catch {
            print("❌ Error codificando MatchData:", error)
        }
    }

    //Envio en background
    func sendMatchResult(match: MatchData) {
        let session = WCSession.default
        print("➡️ Intentando enviar match con transferUserInfo")

        guard session.activationState == .activated else {
            print("❌ Sesión no activada en Watch")
            return
        }

        guard session.isCompanionAppInstalled else {
            print("❌ La app del iPhone no está instalada")
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(match.asCodable())
            let info: [String: Any] = [
                "matchData": data,
                "timestamp": Date().timeIntervalSince1970
            ]
            WCSession.default.transferUserInfo(info)
        } catch {
            print("❌ Error codificando MatchData:", error)
        }
    }

    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print("❌ Transferencia fallida: \(error.localizedDescription)")
        } else {
            print("✅ Datos enviados exitosamente desde el Watch.")
        }
    }
}
