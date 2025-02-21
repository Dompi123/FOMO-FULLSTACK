import Foundation

#if DEBUG
public final class PreviewDataLoader {
    public static let shared = PreviewDataLoader()
    
    private init() {}
    
    public func loadVenues() async throws -> [Venue] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return [.mock]
    }
    
    public func loadPasses() async throws -> [Pass] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [.previewActive, .previewExpired]
    }
    
    public func loadProfile() async throws -> UserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        return .preview
    }
    
    public static func loadPreviewData() -> [String: Any]? {
        guard let url = Bundle.main.url(forResource: "sample_drinks", withExtension: "json", subdirectory: "Preview Content/PreviewData"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json
    }
}
#endif 