import XCTest
@testable import FOMO_FINAL

final class ParameterizationTests: XCTestCase {
    
    // MARK: - Properties
    private var apiSpec: [APIContract]!
    private var frontendEndpoints: [String]!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        // Load API spec
        let specURL = URL(fileURLWithPath: "api-spec.json")
        let specData = try! Data(contentsOf: specURL)
        apiSpec = try! JSONDecoder().decode([APIContract].self, from: specData)
        
        // Extract frontend endpoints
        frontendEndpoints = try! String(contentsOf: URL(fileURLWithPath: "frontend-endpoints.txt"))
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
    }
    
    // MARK: - Tests
    func testEndpointParameterization() {
        // Test that all backend endpoints have corresponding frontend endpoints
        for contract in apiSpec {
            let normalizedPath = normalizeEndpoint(contract.path)
            let hasMatchingFrontend = frontendEndpoints.contains { frontend in
                normalizeEndpoint(frontend).contains(normalizedPath)
            }
            
            XCTAssertTrue(
                hasMatchingFrontend,
                "Backend endpoint \(contract.path) has no matching frontend endpoint"
            )
        }
        
        // Test that all frontend endpoints have corresponding backend endpoints
        for frontend in frontendEndpoints {
            let normalizedFrontend = normalizeEndpoint(frontend)
            let hasMatchingBackend = apiSpec.contains { contract in
                normalizedFrontend.contains(normalizeEndpoint(contract.path))
            }
            
            XCTAssertTrue(
                hasMatchingBackend,
                "Frontend endpoint \(frontend) has no matching backend endpoint"
            )
        }
    }
    
    func testEndpointNaming() {
        // Test that endpoint names follow conventions
        for contract in apiSpec {
            // Operation ID should be camelCase
            XCTAssertTrue(
                contract.operationId.first?.isLowercase == true,
                "Operation ID should start with lowercase: \(contract.operationId)"
            )
            
            // Path should be kebab-case
            let pathComponents = contract.path.split(separator: "/")
            for component in pathComponents where !component.hasPrefix("{") {
                XCTAssertFalse(
                    component.contains("_"),
                    "Path should use hyphens, not underscores: \(contract.path)"
                )
            }
            
            // Parameters should be camelCase
            let params = contract.path.components(separatedBy: "/")
                .filter { $0.hasPrefix("{") && $0.hasSuffix("}") }
                .map { String($0.dropFirst().dropLast()) }
            
            for param in params {
                XCTAssertTrue(
                    param.first?.isLowercase == true,
                    "Parameter should be camelCase: \(param)"
                )
            }
        }
    }
    
    func testResponseTypes() {
        // Test that all response types are defined
        let responseTypes = Set([
            "Venue",
            "Drink",
            "Pass",
            "Profile",
            "Order",
            "APIError"
        ])
        
        for contract in apiSpec {
            let responseType = contract.responseType
            XCTAssertTrue(
                responseTypes.contains(responseType),
                "Unknown response type: \(responseType)"
            )
        }
    }
    
    func testHTTPMethods() {
        // Test that HTTP methods are valid
        let validMethods = Set([
            "GET",
            "POST",
            "PUT",
            "DELETE",
            "PATCH"
        ])
        
        for contract in apiSpec {
            XCTAssertTrue(
                validMethods.contains(contract.method),
                "Invalid HTTP method: \(contract.method)"
            )
        }
    }
    
    // MARK: - Helpers
    private func normalizeEndpoint(_ endpoint: String) -> String {
        endpoint
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9]", with: "", options: .regularExpression)
    }
}

// MARK: - Test Extensions
extension APIContract {
    var responseType: String {
        // Extract response type from operationId
        // e.g. "getVenue" -> "Venue", "createOrder" -> "Order"
        let components = operationId.components(separatedBy: CharacterSet.uppercaseLetters)
        return components.last ?? ""
    }
} 