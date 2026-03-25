//
//  AppDelegate.swift
//  PointPro
//
//  Created by Carlos Suarez on 6/6/25.
//

import Foundation
import UIKit
import UserNotifications
import os

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private let logger = Logger(subsystem: "com.pointpro.app", category: "AppDelegate")

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        PhoneSessionManager.shared  // Activa WCSession al iniciar la app (WacthConectivity)

        // Request notification permissions early so we can deliver match notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                self.logger.error("Failed to request notification authorization: \(error.localizedDescription, privacy: .public)")
            } else {
                self.logger.info("Notification permission granted: \(granted.description)")
            }
        }
        center.delegate = self

        return true
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let matchId = userInfo["matchId"] as? String {
            // Post notification so SwiftUI can observe and navigate
            NotificationCenter.default.post(name: Notification.Name("PointPro_DidReceiveMatchNotification"), object: nil, userInfo: ["matchId": matchId])
            logger.info("Notification tapped for matchId: \(matchId)")
        }
        completionHandler()
    }
}
