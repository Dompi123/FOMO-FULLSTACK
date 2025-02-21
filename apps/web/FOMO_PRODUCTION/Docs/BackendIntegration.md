# FOMO Design System - Backend Integration Guide

## Color Tokens

### Primary Colors
```swift
FOMOTheme.Colors.primary    // #4B0082 (Deep Purple)
FOMOTheme.Colors.secondary  // #000000 (Black)
FOMOTheme.Colors.background // #1A1A1A (Dark Background)
```

### Text Colors
```swift
FOMOTheme.Colors.text           // White
FOMOTheme.Colors.textSecondary  // Gray
```

## Typography System

### Headers (SF Pro Rounded)
```swift
FOMOTheme.Typography.display    // 34pt Bold Rounded
FOMOTheme.Typography.header1    // 28pt Bold Rounded
FOMOTheme.Typography.header2    // 22pt Bold Rounded
```

### Body Text (Space Grotesk)
```swift
FOMOTheme.Typography.bodyLarge    // 18pt
FOMOTheme.Typography.bodyRegular  // 16pt
FOMOTheme.Typography.bodySmall    // 14pt
```

### Captions (Space Grotesk)
```swift
FOMOTheme.Typography.caption1    // 12pt
FOMOTheme.Typography.caption2    // 10pt
```

### Secure Typography
```swift
// Secure text style
Text("Sensitive Data")
    .secureBodyStyle()

// Payment field style
SecureField("Card Number", text: $cardNumber)
    .securePaymentStyle()
```

### Legacy Support
The following mappings are maintained for backward compatibility:
```swift
headlineLarge = display
headlineMedium = header1
headlineSmall = header2
title = header1
body = bodyRegular
caption = caption1
```

## Layout System

### Spacing Grid
```swift
FOMOTheme.Layout.gridSpacing    // 16.0pt
FOMOTheme.Layout.cornerRadius   // 12.0pt
```

### Section Padding
```swift
FOMOTheme.Layout.sectionPadding // EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
```

## Animation Timings

### Interactive Animations
```swift
FOMOTheme.Animations.buttonPress // Interactive spring, duration: 0.2s
FOMOTheme.Animations.cardHover   // Spring, response: 0.3s, damping: 0.7
```

### Standard Animations
```swift
FOMOTheme.Animations.standard    // Ease-in-out, duration: 0.3s
FOMOTheme.Animations.quick      // Ease-in-out, duration: 0.15s
```

## Security Considerations

### Payment Components
- All payment components use secure field handling
- Input validation with proper content types
- Secure animation timings for feedback
- Protected theme values
- All payment text uses `.securePaymentStyle()`
- Sensitive data uses `.secureBodyStyle()`
- Font rendering is optimized for security
- Privacy redaction is applied where needed

### Theme Updates
- Color values are immutable
- Typography system is version controlled
- Layout values are standardized
- Animation timings are optimized for security

### Performance
- Font loading is optimized
- Memory usage is monitored
- Rendering performance is validated

## Integration Notes

1. Color Usage:
   - Use primary color for main CTAs
   - Use secondary color for borders and dividers
   - Background color supports dark mode

2. Typography Rules:
   - Headers use system rounded design
   - Body text uses custom Space Grotesk font
   - Captions maintain consistent scaling

3. Layout Guidelines:
   - Grid spacing for consistent layouts
   - Section padding for container elements
   - Corner radius for UI components

4. Animation Best Practices:
   - Button press for interactive elements
   - Card hover for container animations
   - Standard timing for general transitions
   - Quick timing for micro-interactions

5. Security Guidelines:
   - Use secure styles for payment fields
   - Apply privacy redaction when needed
   - Validate font rendering performance

6. Migration Path:
   - Legacy support is maintained
   - Gradual adoption of new system
   - Performance monitoring in place

## Version Control
- Design system is versioned with semantic versioning
- Breaking changes will be documented
- Migration guides will be provided
- Legacy support is maintained 