import Foundation
import Combine
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    @Published var selectedMatchId: String? = nil

    private var cancellable: Any?

    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name("PointPro_DidReceiveMatchNotification"), object: nil, queue: .main) { [weak self] note in
            if let matchId = note.userInfo?["matchId"] as? String {
                self?.selectedMatchId = matchId
            }
        }
    }
}
