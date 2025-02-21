import Foundation
import OSLog

public enum RollbackError: Error {
    case noValidPreviousVersion
    case rollbackFailed(String)
    case featureFlagError
}

@MainActor
public final class RollbackService {
    private static let logger = Logger(subsystem: "com.fomo", category: "Rollback")
    
    public static func executeRollbackPlan() async throws {
        logger.warning("Initiating rollback procedure")
        
        do {
            // 1. Disable new backend feature flag
            FeatureFlagManager.shared.deactivate(.backendV1)
            
            // 2. Clear active alerts
            MonitoringService.shared.activeAlerts.forEach { alert in
                MonitoringService.shared.clearAlert(alert)
            }
            
            // 3. Notify stakeholders
            NotificationService.shared.sendUrgentNotification(
                title: "Backend Rollback Initiated",
                message: "Automatic rollback triggered due to monitoring alerts"
            )
            
            // 4. Log rollback event
            logger.error("Rollback executed successfully")
            
            // 5. Track analytics
            AnalyticsService.trackEvent(.rollbackExecuted(
                reason: "Monitoring alerts triggered automatic rollback"
            ))
            
        } catch {
            logger.fault("Rollback failed: \(error.localizedDescription)")
            throw RollbackError.rollbackFailed(error.localizedDescription)
        }
    }
    
    public static func validatePostRollback() async throws -> Bool {
        logger.info("Validating post-rollback state")
        
        // 1. Verify feature flags
        guard !FeatureFlagManager.shared.isEnabled(.backendV1) else {
            throw RollbackError.featureFlagError
        }
        
        // 2. Check backend health
        let isHealthy = await NetworkMonitor.shared.verifyBackendConnection()
        guard isHealthy else {
            throw RollbackError.rollbackFailed("Backend health check failed")
        }
        
        // 3. Verify metrics are back to normal
        let metrics = MonitoringService.shared
        
        // Wait for metrics to stabilize
        try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
        
        guard metrics.activeAlerts.isEmpty else {
            throw RollbackError.rollbackFailed("Alerts still active after rollback")
        }
        
        logger.info("Post-rollback validation successful")
        return true
    }
}

// MARK: - Analytics Events
extension AnalyticsEvent {
    static func rollbackExecuted(reason: String) -> AnalyticsEvent {
        .init(name: "rollback_executed",
              properties: ["reason": reason])
    }
} 