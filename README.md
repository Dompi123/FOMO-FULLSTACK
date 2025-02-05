# FOMO - Skip-the-Line Pass Management

FOMO is an iOS application that lets users preview venues, purchase skip-the-line passes, and manage their passes through an intuitive interface.

## Features

- **Venue Discovery**: Browse and search through available venues
- **Pass Management**: View and manage active and expired passes
- **Profile Management**: Update personal information and preferences
- **Secure Payments**: Process payments securely with card tokenization

## Project Structure

```
FOMO_FINAL/
├── App/
│   └── FOMO_FINALApp.swift
├── Core/
│   └── Navigation/
│       └── MainTabView.swift
├── Features/
│   ├── Venues/
│   │   └── Views/
│   │       └── VenueListView.swift
│   ├── Passes/
│   │   └── Views/
│   │       └── MyPassesView.swift
│   └── Profile/
│       └── Views/
│           └── ProfileView.swift
└── Payment/
    ├── PaymentGatewayView.swift
    ├── PaymentViewModel.swift
    └── Tokenization/
        └── TokenizationService.swift
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/fomo.git
```

2. Open the project in Xcode
```bash
cd fomo
open FOMO_FINAL/FOMO_FINAL.xcodeproj
```

3. Build and run the project

## Testing

The project includes comprehensive tests for:
- Payment validation
- View previews
- Integration tests

Run the tests using:
```bash
xcodebuild test -project FOMO_FINAL/FOMO_FINAL.xcodeproj -scheme FOMO_FINAL -destination 'platform=iOS Simulator,name=iPhone 15'
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 