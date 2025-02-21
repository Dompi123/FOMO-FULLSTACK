# FOMO Design System API Specification

## Color System

### Base Colors
```swift
oledBlack  = #000000 // Pure black for OLED displays
vividPink  = #E91E63 // Primary brand color
cyanAccent = #00FFF0 // Secondary accent
```

### Semantic Colors
```swift
primary   = vividPink
secondary = oledBlack
background = oledBlack
surface    = #1A1A1A
text       = .white
textSecondary = .gray
accent     = cyanAccent
```

### Status Colors
```swift
success = #4CAF50
warning = #FFC107
error   = #F44336
```

### Gradients
```swift
vipPurplePink = LinearGradient(
    colors: [#9C27B0, #E91E63],
    startPoint: .leading,
    endPoint: .trailing
)

darkOverlay = LinearGradient(
    colors: [oledBlack.opacity(0.8), oledBlack.opacity(0.2)],
    startPoint: .bottom,
    endPoint: .top
)
```

## Typography System

### Headers (SF Pro Rounded)
```swift
display = 34pt Bold Rounded
header1 = 28pt Bold Rounded
header2 = 22pt Bold Rounded
```

### Body Text (Space Grotesk Medium)
```swift
bodyLarge   = 18pt
bodyRegular = 16pt
bodySmall   = 14pt
```

### Captions (Space Grotesk Medium)
```swift
caption1 = 12pt
caption2 = 10pt
```

## Layout System

### Grid & Spacing
```swift
gridSpacing  = 16.0
cornerRadius = 12.0

spacing = {
    xxSmall: 4,
    xSmall:  8,
    small:   12,
    medium:  16,
    large:   24,
    xLarge:  32,
    xxLarge: 48
}
```

### Section Padding
```swift
sectionPadding = EdgeInsets(
    top: 20,
    leading: 16,
    bottom: 20,
    trailing: 16
)
```

## Animation System

### Interactive Animations
```swift
buttonPress = Animation.interactiveSpring(duration: 0.2)
cardHover   = Animation.spring(response: 0.3, dampingFraction: 0.7)
```

### Standard Animations
```swift
standard = Animation.easeInOut(duration: 0.3)
quick    = Animation.easeInOut(duration: 0.15)
```

## Security Considerations

### Secure Typography
```swift
// Secure text fields
SecureField()
    .securePaymentStyle()
    .textContentType(.oneTimeCode)
    .privacySensitive(true)

// Secure text display
Text()
    .secureBodyStyle()
    .redacted(reason: .privacy)
```

### Performance Guidelines
- Font loading is optimized for first paint
- Color calculations are cached
- Animations use hardware acceleration
- Gradients are precomputed where possible

### Security Requirements
- All payment fields must use `.securePaymentStyle()`
- Sensitive data must use `.secureBodyStyle()`
- Animations must complete within 200ms
- Color values must be immutable

## Integration Requirements

### Minimum Platform Versions
- iOS 17.0+
- Swift 5.9+
- Xcode 15.0+

### Required Frameworks
- SwiftUI
- Foundation

### Asset Requirements
- Space Grotesk Medium font
- SF Pro Rounded (system)
- Dark mode support
- OLED display optimization

### Performance Targets
- First paint < 100ms
- Animation frame rate > 58fps
- Memory impact < 50MB
- CPU usage < 10% during animations

## Version Information
- Current Version: 1.0.0
- Release Date: 2024-02-14
- Minimum Compatibility: iOS 17.0
- Swift Package Manager: Yes
- CocoaPods: No 