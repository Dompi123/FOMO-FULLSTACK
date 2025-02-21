import Foundation
import OSLog

public enum MonitoringMetric: String {
    case errorRate
    case p95Latency
    case successRate
    case securityIncidents
    case pciCompliance
}

public struct AlertConfiguration {
    let metric: MonitoringMetric
    let threshold: Double
    let duration: TimeInterval
    let severity: AlertSeverity
    
    public init(
        metric: MonitoringMetric,
        threshold: Double,
        duration: TimeInterval = 300, // 5 minutes
        severity: AlertSeverity = .warning
    ) {
        self.metric = metric
        self.threshold = threshold
        self.duration = duration
        self.severity = severity
    }
}

public enum AlertSeverity: String {
    case info
    case warning
    case critical
}

public struct Alert: Identifiable {
    public let id = UUID()
    let metric: MonitoringMetric
    let value: Double
    let threshold: Double
    let timestamp: Date
    let severity: AlertSeverity
}

@MainActor
public final class MonitoringService: ObservableObject {
    public static let shared = MonitoringService()
    
    private let logger = Logger(subsystem: "com.fomo", category: "Monitoring")
    private var alertConfigurations: [AlertConfiguration] = []
    private var alertHandlers: [(Alert) -> Void] = []
    
    @Published private(set) var activeAlerts: [Alert] = []
    
    private init() {}
    
    public func configure(alerts: [AlertConfiguration]) {
        self.alertConfigurations = alerts
        logger.info("Configured monitoring with \(alerts.count) alert rules")
    }
    
    public func onAlert(handler: @escaping (Alert) -> Void) {
        alertHandlers.append(handler)
    }
    
    public func track(_ metric: MonitoringMetric, value: Double) {
        for config in alertConfigurations {
            if config.metric == metric && value >= config.threshold {
                let alert = Alert(
                    metric: metric,
                    value: value,
                    threshold: config.threshold,
                    timestamp: Date(),
                    severity: config.severity
                )
                
                handleAlert(alert)
            }
        }
        
        // Log metric
        logger.info("\(metric.rawValue): \(value)")
        
        // Send to analytics
        AnalyticsService.trackEvent(.metricRecorded(metric: metric, value: value))
    }
    
    private func handleAlert(_ alert: Alert) {
        activeAlerts.append(alert)
        
        // Log alert
        logger.error("Alert triggered: \(alert.metric.rawValue) = \(alert.value) (threshold: \(alert.threshold))")
        
        // Notify handlers
        for handler in alertHandlers {
            handler(alert)
        }
        
        // Send to analytics
        AnalyticsService.trackEvent(.alertTriggered(alert))
    }
    
    public func clearAlert(_ alert: Alert) {
        activeAlerts.removeAll { $0.id == alert.id }
        logger.info("Cleared alert: \(alert.metric.rawValue)")
    }
}

// MARK: - Analytics Events
extension AnalyticsEvent {
    static func metricRecorded(metric: MonitoringMetric, value: Double) -> AnalyticsEvent {
        .init(name: "metric_recorded",
              properties: ["metric": metric.rawValue, "value": value])
    }
    
    static func alertTriggered(_ alert: Alert) -> AnalyticsEvent {
        .init(name: "alert_triggered",
              properties: [
                "metric": alert.metric.rawValue,
                "value": alert.value,
                "threshold": alert.threshold,
                "severity": alert.severity.rawValue
              ])
    }
} 