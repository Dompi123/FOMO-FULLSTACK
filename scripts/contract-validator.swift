import Foundation

struct APIContract: Codable {
    let path: String
    let method: String
    let operationId: String
    let tags: [String]
}

struct ValidationResult {
    let unmatchedBackend: [APIContract]
    let unmatchedFrontend: [String]
    let matchedEndpoints: [(frontend: String, backend: APIContract)]
}

func normalizeEndpoint(_ endpoint: String) -> String {
    // Remove HTTP method prefixes
    var normalized = endpoint
        .replacingOccurrences(of: "get|post|put|delete", with: "", options: [.regularExpression, .caseInsensitive])
    
    // Remove parameter declarations
    normalized = normalized.replacingOccurrences(
        of: "\\(.*?\\)",
        with: "",
        options: .regularExpression
    )
    
    // Remove common parameter names
    normalized = normalized.replacingOccurrences(
        of: "id|identifier|uuid|venueId|drinkId|passId|orderId",
        with: "id",
        options: [.regularExpression, .caseInsensitive]
    )
    
    // Standardize common words
    let commonWords = [
        "venue": "venue",
        "drink": "drink",
        "pass": "pass",
        "order": "order",
        "profile": "profile"
    ]
    
    for (key, value) in commonWords {
        normalized = normalized.replacingOccurrences(of: key, with: value, options: .caseInsensitive)
    }
    
    // Clean up and standardize
    return normalized
        .lowercased()
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
}

func endpointMatches(frontend: String, backend: APIContract) -> Bool {
    let normalizedFrontend = normalizeEndpoint(frontend)
    let normalizedOperation = normalizeEndpoint(backend.operationId)
    let normalizedPath = normalizeEndpoint(backend.path)
    
    // Direct operation ID match
    if normalizedFrontend == normalizedOperation {
        return true
    }
    
    // Path component match
    let pathComponents = backend.path.components(separatedBy: "/")
        .filter { !$0.isEmpty && !$0.hasPrefix("{") }
        .map { normalizeEndpoint($0) }
    
    // Check if any path component matches
    let matchesPathComponent = pathComponents.contains { component in
        normalizedFrontend.contains(component) || component.contains(normalizedFrontend)
    }
    
    // Check operation ID similarity
    let matchesOperation = normalizedOperation.contains(normalizedFrontend) ||
                          normalizedFrontend.contains(normalizedOperation)
    
    // Check tag relevance
    let matchesTags = backend.tags.contains { tag in
        normalizedFrontend.contains(tag.lowercased())
    }
    
    return matchesPathComponent || matchesOperation || matchesTags
}

func validateContracts() throws -> ValidationResult {
    // Read frontend endpoints
    let frontendEndpoints = try String(contentsOfFile: "frontend_endpoints.txt", encoding: .utf8)
        .components(separatedBy: .newlines)
        .filter { !$0.isEmpty && !$0.hasPrefix("//") }
    
    // Read and parse API spec
    let apiSpecURL = URL(fileURLWithPath: "api-spec.json")
    let apiSpec = try JSONDecoder().decode([APIContract].self, from: Data(contentsOf: apiSpecURL))
    
    // Match endpoints with improved flexibility
    var unmatchedBackend = [APIContract]()
    var unmatchedFrontend = [String]()
    var matchedEndpoints = [(frontend: String, backend: APIContract)]()
    
    // First pass: Direct matches
    for endpoint in apiSpec {
        if let matchingFrontend = frontendEndpoints.first(where: { endpointMatches(frontend: $0, backend: endpoint) }) {
            matchedEndpoints.append((frontend: matchingFrontend, backend: endpoint))
        } else {
            unmatchedBackend.append(endpoint)
        }
    }
    
    // Second pass: Fuzzy matches for remaining endpoints
    unmatchedFrontend = frontendEndpoints.filter { frontend in
        !matchedEndpoints.contains { $0.frontend == frontend }
    }
    
    return ValidationResult(
        unmatchedBackend: unmatchedBackend,
        unmatchedFrontend: unmatchedFrontend,
        matchedEndpoints: matchedEndpoints
    )
}

// Execute validation
do {
    let result = try validateContracts()
    
    // Generate detailed report
    var report = "Contract Validation Report\n"
    report += "========================\n\n"
    
    report += "✅ Matched Endpoints (\(result.matchedEndpoints.count)):\n"
    for match in result.matchedEndpoints.sorted(by: { $0.backend.path < $1.backend.path }) {
        report += "  Frontend: \(match.frontend)\n"
        report += "    -> Backend: \(match.backend.path) [\(match.backend.method)]\n"
        report += "    -> Operation: \(match.backend.operationId)\n"
        report += "    -> Tags: \(match.backend.tags.joined(separator: ", "))\n\n"
    }
    
    if !result.unmatchedBackend.isEmpty {
        report += "\n❌ Unmatched Backend Endpoints (\(result.unmatchedBackend.count)):\n"
        for endpoint in result.unmatchedBackend.sorted(by: { $0.path < $1.path }) {
            report += "  \(endpoint.path) [\(endpoint.method)]\n"
            report += "  Operation: \(endpoint.operationId)\n"
            report += "  Tags: \(endpoint.tags.joined(separator: ", "))\n\n"
        }
    }
    
    if !result.unmatchedFrontend.isEmpty {
        report += "\n⚠️ Unmatched Frontend Endpoints (\(result.unmatchedFrontend.count)):\n"
        for endpoint in result.unmatchedFrontend.sorted() {
            report += "  \(endpoint)\n"
        }
    }
    
    try report.write(toFile: "contract_validation.txt", atomically: true, encoding: .utf8)
    print("✅ Validation complete. See contract_validation.txt for details.")
    
    // Exit with status code based on validation result
    exit(result.unmatchedBackend.isEmpty && result.unmatchedFrontend.isEmpty ? 0 : 1)
} catch {
    print("❌ Validation failed: \(error)")
    exit(1)
} 