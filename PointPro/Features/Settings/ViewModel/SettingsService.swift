import Foundation
import SwiftUI

@MainActor
final class SettingsService: ObservableObject {
    static let shared = SettingsService()

    // Keys
    @AppStorage("pp.enableNotifications") var enableNotifications: Bool = true
    @AppStorage("pp.autoSendOnFinish") var autoSendOnFinish: Bool = true
    @AppStorage("pp.savePartialOnFinish") var savePartialOnFinish: Bool = true
    @AppStorage("pp.hapticOnFinish") var hapticOnFinish: Bool = true
    @AppStorage("pp.defaultMatchFormat") var defaultMatchFormatRaw: String = "Best of One"
    @AppStorage("pp.accentColor") var accentColorName: String = "PPBlue"

    var defaultMatchFormat: MatchFormat {
        MatchFormat(rawValue: defaultMatchFormatRaw) ?? .bo1
    }

    var accentColor: Color {
        // Map stored asset name to Color asset; fallback to PPBlue
        return Color(accentColorName)
    }

    // Available accent color options (should match Asset Catalog names)
    let accentOptions: [String] = ["PPBlue", "PPBeige", "PPGreenBall"]

    private init() {}
}
