import Foundation
import SwiftUI

@MainActor
final class WatchSettingsService: ObservableObject {
    static let shared = WatchSettingsService()

    @AppStorage("pp.defaultMatchFormat") var defaultMatchFormatRaw: String = "Best of One" { didSet { objectWillChange.send() } }
    @AppStorage("pp.defaultPosition") var defaultPositionRaw: String = "right" { didSet { objectWillChange.send() } }
    @AppStorage("pp.accentColor") var accentColorName: String = "PPBlue" { didSet { objectWillChange.send() } }

    var defaultMatchFormat: MatchFormat {
        MatchFormat(rawValue: defaultMatchFormatRaw) ?? .bo1
    }

    var defaultPosition: PlayerSide {
        PlayerSide(rawValue: defaultPositionRaw) ?? .right
    }

    private init() {}
}
