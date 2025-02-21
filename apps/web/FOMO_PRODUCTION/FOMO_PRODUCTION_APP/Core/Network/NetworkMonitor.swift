import Foundation
import Network
import OSLog

@MainActor
public final class NetworkMonitor: ObservableObject {
    public static let shared = NetworkMonitor()
    
    @Published private(set) var isConnected = true
    @Published private(set) var connectionType = NWInterface.InterfaceType.other
    
    private let monitor = NWPathMonitor()
    private let logger = Logger(subsystem: "com.fomo", category: "NetworkMonitor")
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        setupMonitor()
    }
    
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type ?? .other
                
                if path.status == .satisfied {
                    self?.logger.info("Network connection established")
                } else {
                    self?.logger.error("Network connection lost")
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    public func verifyBackendConnection() async -> Bool {
        do {
            let request = URLRequest(url: APIConstants.baseURL.appendingPathComponent("/health"))
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid response type from health check")
                return false
            }
            
            if httpResponse.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String {
                let isOperational = status == "operational"
                logger.info("Backend health check: \(isOperational ? "operational" : "degraded")")
                return isOperational
            }
            
            logger.error("Backend health check failed with status: \(httpResponse.statusCode)")
            return false
            
        } catch {
            logger.error("Backend health check failed: \(error.localizedDescription)")
            return false
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

enum BackendStatus {
    case operational
    case degraded
    case down
    case unknown
}

struct HealthCheck: Codable {
    let status: String
} 