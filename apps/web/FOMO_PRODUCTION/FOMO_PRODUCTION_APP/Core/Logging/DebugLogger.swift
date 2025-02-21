import Foundation
import os.log

public final class DebugLogger {
    private let category: String
    private let logger = Logger()
    
    public init(category: String) {
        self.category = category
    }
    
    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        logger.debug("[\(self.category)] \(filename):\(line) - \(function) | \(message)")
    }
    
    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        logger.error("[\(self.category)] \(filename):\(line) - \(function) | \(message)")
    }
    
    public func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        logger.warning("[\(self.category)] \(filename):\(line) - \(function) | \(message)")
    }
    
    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let filename = (file as NSString).lastPathComponent
        logger.info("[\(self.category)] \(filename):\(line) - \(function) | \(message)")
    }
    
    func logError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        error(message, file: file, function: function, line: line)
    }
} 