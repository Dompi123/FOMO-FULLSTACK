import Foundation

/// Manages data persistence for the FOMO app
@MainActor
public final class StorageManager: ObservableObject {
    public static let shared = StorageManager()
    
    private let keychain: KeychainManager
    private let userDefaults: UserDefaults
    
    public init(keychain: KeychainManager = .shared, userDefaults: UserDefaults = .standard) {
        self.keychain = keychain
        self.userDefaults = userDefaults
    }
    
    // MARK: - UserDefaults Storage
    
    public func save(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func load(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // MARK: - Keychain Storage
    
    public func saveSecure(_ string: String, forKey key: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw StorageError.stringEncodingFailed
        }
        try keychain.save(data, for: key)
    }
    
    public func loadSecure(forKey key: String) throws -> String {
        let data = try keychain.load(for: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw StorageError.stringDecodingFailed
        }
        return string
    }
    
    public func removeSecure(forKey key: String) throws {
        try keychain.delete(for: key)
    }
}

public enum StorageError: LocalizedError {
    case stringEncodingFailed
    case stringDecodingFailed
    
    public var errorDescription: String? {
        switch self {
        case .stringEncodingFailed:
            return "Failed to encode string to data"
        case .stringDecodingFailed:
            return "Failed to decode data to string"
        }
    }
} 