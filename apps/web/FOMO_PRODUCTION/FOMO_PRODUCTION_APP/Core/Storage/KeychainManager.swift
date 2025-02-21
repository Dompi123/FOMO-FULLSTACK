import Foundation
import Security
import OSLog

/// Manages secure storage and rotation of sensitive data
public final class KeychainManager {
    public static let shared = KeychainManager()
    private let logger = Logger(subsystem: "com.fomo", category: "KeychainManager")
    
    private init() {}
    
    /// Rotates API keys with secure generation
    /// - Parameter completion: Called with success/failure of rotation
    public func rotateKeys() async throws {
        logger.info("Starting key rotation")
        
        do {
            let newKey = try generateSecureKey()
            let oldKey = try get(.apiKey)
            
            // Store new key
            try set(newKey, for: .apiKey)
            
            // Verify API client accepts new key
            try await APIClient.shared.validateAPIKey(newKey)
            
            logger.info("Key rotation successful")
            
        } catch {
            logger.error("Key rotation failed: \(error.localizedDescription)")
            throw KeychainError.keyRotationFailed(error)
        }
    }
    
    /// Generates a cryptographically secure key
    private func generateSecureKey() throws -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        
        guard status == errSecSuccess else {
            logger.fault("Failed to generate secure key")
            throw KeychainError.keyGenerationFailed
        }
        
        return Data(bytes).base64EncodedString()
    }
    
    /// Sets a value in the keychain
    /// - Parameters:
    ///   - value: The value to store
    ///   - key: The key to store it under
    public func set(_ value: String, for key: KeychainKey) throws {
        var query = key.baseQuery
        query[kSecValueData as String] = value.data(using: .utf8)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            try update(value, for: key)
        } else if status != errSecSuccess {
            throw KeychainError.setFailed(status)
        }
    }
    
    /// Gets a value from the keychain
    /// - Parameter key: The key to retrieve
    /// - Returns: The stored value
    public func get(_ key: KeychainKey) throws -> String {
        var query = key.baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.getFailed(status)
        }
        
        return value
    }
    
    /// Updates a value in the keychain
    /// - Parameters:
    ///   - value: The new value
    ///   - key: The key to update
    private func update(_ value: String, for key: KeychainKey) throws {
        let query = key.baseQuery
        let attributes = [kSecValueData: value.data(using: .utf8)]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError.updateFailed(status)
        }
    }
    
    /// Deletes a value from the keychain
    /// - Parameter key: The key to delete
    public func delete(_ key: KeychainKey) throws {
        let status = SecItemDelete(key.baseQuery as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.deleteFailed(status)
        }
    }
}

// MARK: - Error Types
public enum KeychainError: LocalizedError {
    case setFailed(OSStatus)
    case getFailed(OSStatus)
    case updateFailed(OSStatus)
    case deleteFailed(OSStatus)
    case keyGenerationFailed
    case keyRotationFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .setFailed(let status):
            return "Failed to set keychain value: \(status)"
        case .getFailed(let status):
            return "Failed to get keychain value: \(status)"
        case .updateFailed(let status):
            return "Failed to update keychain value: \(status)"
        case .deleteFailed(let status):
            return "Failed to delete keychain value: \(status)"
        case .keyGenerationFailed:
            return "Failed to generate secure key"
        case .keyRotationFailed(let error):
            return "Failed to rotate keys: \(error.localizedDescription)"
        }
    }
}

// MARK: - Key Types
public enum KeychainKey {
    case apiKey
    case baseURL
    case apiToken
    
    var baseQuery: [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: rawValue,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        #if !targetEnvironment(simulator)
        query[kSecAttrAccessControl as String] = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleAfterFirstUnlock,
            .privateKeyUsage,
            nil
        )
        #endif
        
        return query
    }
    
    private var rawValue: String {
        switch self {
        case .apiKey: return "com.fomo.apikey"
        case .baseURL: return "com.fomo.baseurl"
        case .apiToken: return "com.fomo.apitoken"
        }
    }
} 