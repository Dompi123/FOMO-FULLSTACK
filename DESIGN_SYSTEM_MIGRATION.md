# FOMO Design System Migration Guide

## Current State
The FOMO app has successfully migrated to a modern design system approach that combines:
1. SwiftUI's built-in styling system for standard components
2. `FOMOTheme` for custom brand colors and typography

## Design System Components

### Colors (FOMOTheme.Colors)
```swift
// Brand Colors
static let vividPink = Color(hex: 0xE91E63)
static let oledBlack = Color(hex: 0x000000)
static let cyanAccent = Color(hex: 0x00BCD4)

// Semantic Colors
static let background = oledBlack
static let primary = vividPink
static let secondary = cyanAccent
static let surface = Color(hex: 0xF5F5F5)
static let text = Color.white
static let textSecondary = Color.gray

// State Colors
static let success = Color(hex: 0x4CAF50)
static let warning = Color(hex: 0xFFC107)
static let error = Color(hex: 0xF44336)
```

### Typography (FOMOTheme.Typography)
```swift
// Legacy Styles
static let h1 = TextStyle(
    font: .custom(sfProDisplay, size: 32).weight(.bold),
    lineSpacing: 1.2,
    letterSpacing: -0.5
)

// Modern Styles
static let titleLarge = TextStyle(
    font: .custom(spaceGroteskBold, size: 28),
    lineSpacing: 1.3,
    letterSpacing: -0.4
)
```

## Usage Guidelines

### Standard UI Components
For standard UI components, use SwiftUI's built-in modifiers:
```swift
Text("Heading")
    .font(.headline)
    .foregroundStyle(.primary)

Text("Body")
    .font(.body)
    .foregroundStyle(.secondary)
```

### Custom Brand Elements
For custom brand elements or components that need specific styling:
```swift
Text("Brand Heading")
    .fomoTextStyle(FOMOTheme.Typography.titleLarge)
    .foregroundColor(FOMOTheme.Colors.primary)
```

### When to Use Each
1. **SwiftUI Built-in**: 
   - Standard UI components
   - System-integrated features
   - Dynamic Type support
   - Dark mode compatibility

2. **FOMOTheme**:
   - Brand-specific colors
   - Custom typography
   - Special UI components
   - Consistent brand styling

## Best Practices
1. Prefer SwiftUI's built-in styling system for standard components
2. Use `FOMOTheme` for brand-specific styling needs
3. Maintain dark mode compatibility
4. Support Dynamic Type where possible
5. Keep custom styling minimal and purposeful

## Validation
After any styling changes:
1. Test in light and dark mode
2. Verify Dynamic Type scaling
3. Check accessibility features
4. Ensure brand consistency
5. Validate on different devices 