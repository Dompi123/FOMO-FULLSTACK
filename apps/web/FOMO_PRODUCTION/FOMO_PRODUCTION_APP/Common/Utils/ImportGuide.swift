import Foundation

/// Import Rules for FOMO_FINAL
///
/// - Important: Never use module-style imports
///   ✅ import SwiftUI
///   ✅ Direct file access (same target)
///   ❌ import Features.Venues.ViewModels
///   ❌ import Payment.ViewModels
///
/// Guidelines:
/// 1. Use direct imports since all files are in the same target
/// 2. No module-style imports (Features.*, Payment.*, etc)
/// 3. Use typealiases for common types when needed
/// 4. @testable imports are forbidden in production code
///
enum ImportGuide {
    // Architectural marker - This enum exists to document import rules
} 