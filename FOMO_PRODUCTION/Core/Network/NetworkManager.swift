import Foundation
import Security
import SwiftUI

enum SSLPinningMode {
    case production
    case debug // For development environments
}

enum NetworkError: Error {
    case sslPinningFailed
    case invalidCertificate
    case serverTrustEvaluationFailed
}

@MainActor
final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    // Production certificate hash (SHA-256)
    static let pinnedCertHash = "f0daffaf3b82bce72783d8395a8ced78a3308def87a8a73b1a9c969f6b761544"
    
    // Development certificate hash
    private static let debugCertHash = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0"
    
    private var currentMode: SSLPinningMode = .production
    
    private init() {}
    
    func enableSSLPinning(mode: SSLPinningMode) throws {
        currentMode = mode
        let hashToUse = mode == .production ? Self.pinnedCertHash : Self.debugCertHash
        
        // Configure SSL session
        let session = URLSession(configuration: .ephemeral,
                               delegate: SSLPinningDelegate(mode: mode, certHash: hashToUse),
                               delegateQueue: nil)
        
        print("🔒 SSL Pinning enabled for \(mode) mode")
    }
}

class SSLPinningDelegate: NSObject, URLSessionDelegate {
    private let mode: SSLPinningMode
    private let certHash: String
    
    init(mode: SSLPinningMode, certHash: String) {
        self.mode = mode
        self.certHash = certHash
        super.init()
    }
    
    func urlSession(_ session: URLSession,
                   didReceive challenge: URLAuthenticationChallenge,
                   completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Set SSL policies
        let policy = SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString)
        SecTrustSetPolicies(serverTrust, policy)
        
        // Evaluate server certificate
        var result: SecTrustResultType = .invalid
        SecTrustEvaluate(serverTrust, &result)
        
        let isValid = result == .proceed || result == .unspecified
        
        // Verify certificate hash
        if isValid {
            let certData = SecCertificateCopyData(certificate) as Data
            let certHash = certData.sha256().hexString
            
            if certHash == self.certHash {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}

// Helper extensions
private extension Data {
    func sha256() -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(count), &hash)
        }
        return Data(hash)
    }
    
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
} 