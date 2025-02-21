import Foundation
import OSLog

public enum Metrics {
    private static let logger = Logger(subsystem: "com.fomo", category: "Metrics")
    private static let performanceBaseline: TimeInterval = 0.2 // 200ms
    
    public static func logRequest(endpoint: String, duration: TimeInterval, success: Bool) {
        let metrics: [String: Any] = [
            "endpoint": endpoint,
            "duration_ms": duration * 1000,
            "success": success,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        
        // Log metrics
        logger.info("\(metrics)")
        
        // Track performance against baseline
        if duration > performanceBaseline {
            logger.warning("Performance degradation: \(endpoint) took \(duration)s")
        }
        
        // Send to analytics service
        AnalyticsService.trackEvent(.networkRequest(metrics))
    }
    
    public static func trackResponseCode(_ code: Int) {
        let metrics: [String: Any] = [
            "status_code": code,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        
        logger.info("Response code: \(code)")
        AnalyticsService.trackEvent(.apiResponse(metrics))
    }
    
    public static func trackError(code: String) {
        let metrics: [String: Any] = [
            "error_code": code,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        
        logger.error("API error: \(code)")
        AnalyticsService.trackEvent(.apiError(metrics))
    }
    
    public static func trackRateLimit() {
        logger.warning("Rate limit exceeded")
        AnalyticsService.trackEvent(.rateLimitExceeded)
    }
    
    public static func trackAuthFailure() {
        logger.error("Authentication failure")
        AnalyticsService.trackEvent(.authFailure)
    }
    
    public static func validatePerformance() -> Bool {
        // Implementation would validate against stored baseline
        return true
    }
}

// MARK: - Analytics Events
extension AnalyticsEvent {
    static func networkRequest(_ metrics: [String: Any]) -> AnalyticsEvent {
        .init(name: "network_request", properties: metrics)
    }
    
    static func apiResponse(_ metrics: [String: Any]) -> AnalyticsEvent {
        .init(name: "api_response", properties: metrics)
    }
    
    static func apiError(_ metrics: [String: Any]) -> AnalyticsEvent {
        .init(name: "api_error", properties: metrics)
    }
    
    static let rateLimitExceeded = AnalyticsEvent(name: "rate_limit_exceeded")
    static let authFailure = AnalyticsEvent(name: "auth_failure")
} 