# FOMO App

A modern iOS application for managing venue passes, browsing venues, and ordering drinks. Built with SwiftUI for iOS 18.1.

## Features

- **Venue Discovery**: Browse and search through available venues
- **Digital Passes**: Manage your venue passes and tickets
- **Drink Ordering**: View drink menus and place orders
- **Profile Management**: Manage your profile and preferences
- **Payment Integration**: Secure payment processing for passes and drinks

## Technical Details

- iOS Target: 18.1+
- Device Support: iPhone 15 and newer
- Framework: SwiftUI
- Architecture: MVVM
- Preview Support: Full SwiftUI Preview integration

## Setup Requirements

- Xcode 15.4+
- iOS 18.1+ Simulator or Device
- Swift 5.9+

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/Dompi123/fomofinal.git
```

2. Open the project:
```bash
cd fomofinal
xcodegen generate
open FOMO_FINAL.xcodeproj
```

3. Run the app in the simulator (FOMO_Simulator) or on a device

## Preview Data

The app includes preview data for testing and development:
- Sample venues
- Preview passes
- Mock drink menus
- Test user profiles

## Development

- Use `scripts/validate_ios17_simulator.sh` for simulator validation
- Run `scripts/nuclear_reset.sh` for clean project reset
- Preview data can be found in `FOMO_FINAL/Preview Content`

## Testing

- Unit Tests: `FOMO_FINALTests` target
- UI Tests: `FOMO_FINALUITests` target
- Preview Tests: Available in debug builds

## License

Copyright © 2025 FOMO. All rights reserved. 