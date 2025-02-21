import Foundation
import OSLog

/// Manages production logging with rotation and filtering
final class ProductionLogger {
    static let shared = ProductionLogger()
    
    private let logger: Logger
    private let logRotationInterval: TimeInterval = 7 * 24 * 60 * 60 // 7 days
    private let maxLogSize: Int = 50 * 1024 * 1024 // 50MB
    
    private init() {
        logger = Logger(subsystem: "com.fomo", category: "Production")
    }
    
    /// Configures production logging
    static func configure() {
        shared.setupLogRotation()
        shared.log("Production logging configured", type: .info)
    }
    
    /// Logs a message with the specified type
    /// - Parameters:
    ///   - message: The message to log
    ///   - type: The type of log entry
    func log(_ message: String, type: OSLogType) {
        switch type {
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .error:
            logger.error("\(message)")
        case .fault:
            logger.fault("\(message)")
        default:
            logger.notice("\(message)")
        }
    }
    
    /// Sets up log rotation based on time and size
    private func setupLogRotation() {
        // Create log directory if needed
        let logDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Logs")
        
        try? FileManager.default.createDirectory(at: logDirectory, withIntermediateDirectories: true)
        
        // Schedule log rotation
        Timer.scheduledTimer(withTimeInterval: logRotationInterval, repeats: true) { [weak self] _ in
            self?.rotateLogFiles(in: logDirectory)
        }
        
        // Initial rotation
        rotateLogFiles(in: logDirectory)
    }
    
    /// Rotates log files based on age and size
    /// - Parameter directory: The directory containing log files
    private func rotateLogFiles(in directory: URL) {
        do {
            let fileManager = FileManager.default
            let logFiles = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey])
            
            // Remove old log files
            let oldFiles = logFiles.filter { file in
                guard let creationDate = try? file.resourceValues(forKeys: [.creationDateKey]).creationDate else {
                    return false
                }
                return Date().timeIntervalSince(creationDate) > logRotationInterval
            }
            
            try oldFiles.forEach { try fileManager.removeItem(at: $0) }
            
            // Check total size and remove oldest if needed
            var remainingFiles = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey, .fileSizeKey])
            var totalSize = remainingFiles.reduce(0) { sum, file in
                guard let size = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
                    return sum
                }
                return sum + size
            }
            
            // Sort by creation date
            remainingFiles.sort { file1, file2 in
                guard let date1 = try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate,
                      let date2 = try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate else {
                    return false
                }
                return date1 < date2
            }
            
            // Remove oldest files until under size limit
            while totalSize > maxLogSize, let oldestFile = remainingFiles.first {
                try fileManager.removeItem(at: oldestFile)
                if let size = try? oldestFile.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize -= size
                }
                remainingFiles.removeFirst()
            }
            
            logger.info("Log rotation completed successfully")
        } catch {
            logger.error("Log rotation failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Convenience Methods
extension ProductionLogger {
    static func info(_ message: String) {
        shared.log(message, type: .info)
    }
    
    static func error(_ message: String) {
        shared.log(message, type: .error)
    }
    
    static func debug(_ message: String) {
        #if DEBUG
        shared.log(message, type: .debug)
        #endif
    }
    
    static func fault(_ message: String) {
        shared.log(message, type: .fault)
    }
} 