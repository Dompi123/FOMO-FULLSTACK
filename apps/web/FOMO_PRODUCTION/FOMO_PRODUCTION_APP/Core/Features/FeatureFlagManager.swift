import Foundation
import OSLog

public enum FeatureFlag: String {
    case backendV1
    case newPaymentFlow
    case enhancedSecurity
}

public enum RolloutStrategy {
    case percentage(Double)
    case userIds([String])
    case all
    case none
}

@MainActor
public final class FeatureFlagManager: ObservableObject {
    public static let shared = FeatureFlagManager()
    
    private let logger = Logger(subsystem: "com.fomo", category: "FeatureFlags")
    private let defaults = UserDefaults.standard
    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    @Published private var activeFlags: [FeatureFlag: RolloutStrategy] = [:]
    
    private init() {
        loadPersistedFlags()
    }
    
    public func activate(_ flag: FeatureFlag, for strategy: RolloutStrategy) {
        activeFlags[flag] = strategy
        persistFlags()
        logger.info("Activated feature flag: \(flag.rawValue) with strategy: \(String(describing: strategy))")
        AnalyticsService.trackEvent(.featureFlagChanged(flag: flag, enabled: true))
    }
    
    public func deactivate(_ flag: FeatureFlag) {
        activeFlags[flag] = .none
        persistFlags()
        logger.info("Deactivated feature flag: \(flag.rawValue)")
        AnalyticsService.trackEvent(.featureFlagChanged(flag: flag, enabled: false))
    }
    
    public func isEnabled(_ flag: FeatureFlag) -> Bool {
        guard let strategy = activeFlags[flag] else { return false }
        
        switch strategy {
        case .all:
            return true
        case .none:
            return false
        case .percentage(let percentage):
            // Use device ID for consistent user experience
            let hash = deviceId.hash
            let normalized = Double(abs(hash) % 100) / 100.0
            return normalized < percentage / 100.0
        case .userIds(let ids):
            return ids.contains(deviceId)
        }
    }
    
    private func loadPersistedFlags() {
        guard let data = defaults.data(forKey: "feature_flags"),
              let flags = try? JSONDecoder().decode([String: RolloutStrategy].self, from: data) else {
            return
        }
        
        activeFlags = Dictionary(uniqueKeysWithValues: flags.compactMap { key, value in
            guard let flag = FeatureFlag(rawValue: key) else { return nil }
            return (flag, value)
        })
    }
    
    private func persistFlags() {
        let flagData = Dictionary(uniqueKeysWithValues: activeFlags.map { ($0.key.rawValue, $0.value) })
        if let data = try? JSONEncoder().encode(flagData) {
            defaults.set(data, forKey: "feature_flags")
        }
    }
}

// MARK: - Analytics Events
extension AnalyticsEvent {
    static func featureFlagChanged(flag: FeatureFlag, enabled: Bool) -> AnalyticsEvent {
        .init(name: "feature_flag_changed",
              properties: ["flag": flag.rawValue, "enabled": enabled])
    }
} 