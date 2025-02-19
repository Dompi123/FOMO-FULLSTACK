Always start with 'YOOO!!'

**You are building the frontend of an iOS app called FOMO using SwiftUI that lets users preview venues, purchase skip-the-line passes, manage passes, and order drinks through an intuitive interface with three main tabs: Venues, My Passes, and My Profile.**   

#Important Rules
    -Always add debug logs & comments in the code for easier debug & readability
    -Every time you choose to apply rule(s), explicitly state the rule(s) in the output
    -You can abbreviate the rule description to a single word or phrase
    -Maintain iOS 18.1 compatibility while preserving iOS 17 features

#UI/UX Rules
    -SwiftUI Animations & Transitions
        -Custom transitions between views
        -Smooth loading states
        -Interactive feedback animations
    -Custom Color Schemes & Theming
        -Consistent color palette
        -Dark/Light mode support
        -Dynamic color adaptation
    -Asset Management
        -Vector assets for scalability
        -Image caching and loading states
        -Proper asset catalogs organization
    -Accessibility Support
        -VoiceOver compatibility
        -Dynamic Type support
        -Semantic colors and contrast
    -Custom ViewModifiers
        -Reusable style modifiers
        -Consistent UI components
        -Shared animation patterns

#Project Structure
├── FOMO
│   ├── App
│   │   ├── FOMOApp.swift
│   │   └── AppDelegate.swift
│   ├── Features
│   │   ├── Venues
│   │   │   ├── Views
│   │   │   │   ├── VenueListView.swift
│   │   │   │   ├── VenueDetailView.swift
│   │   │   │   ├── VenueCardView.swift
│   │   │   │   └── Components/
│   │   │   ├── ViewModels
│   │   │   │   ├── VenueListViewModel.swift
│   │   │   │   └── VenueDetailViewModel.swift
│   │   │   └── Models
│   │   │       └── VenueModels.swift
│   │   ├── Drinks
│   │   │   ├── Views
│   │   │   │   ├── DrinkMenuView.swift
│   │   │   │   ├── DrinkRowView.swift
│   │   │   │   └── CheckoutView.swift
│   │   │   ├── ViewModels
│   │   │   │   ├── DrinkMenuViewModel.swift
│   │   │   │   └── CheckoutViewModel.swift
│   │   │   └── Models
│   │   │       ├── DrinkItem.swift
│   │   │       └── DrinkOrder.swift
│   │   ├── Passes
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   └── Profile
│   │       ├── Views/
│   │       ├── ViewModels/
│   │       └── Models/
│   ├── Core
│   │   ├── Navigation
│   │   │   └── MainTabView.swift
│   │   ├── Network
│   │   │   ├── APIClient.swift
│   │   │   ├── Endpoints.swift
│   │   │   └── RequestModels/
│   │   ├── Storage
│   │   │   ├── CoreDataManager.swift
│   │   │   └── KeychainManager.swift
│   │   └── Payment
│   │       └── PaymentManager.swift
│   ├── Common
│   │   ├── Models
│   │   │   ├── DTOs/
│   │   │   └── Domain/
│   │   ├── UI
│   │   │   ├── Components/
│   │   │   └── Styles/
│   │   └── Utils
│   │       ├── Constants.swift
│   │       ├── Extensions/
│   │       └── Helpers/
│   └── Resources
       ├── Assets.xcassets
       ├── Colors.xcassets
       └── Localizable.strings

#Tech Stack
    -SwiftUI and Swift
    -iOS 18.1 Target with iOS 17 Compatibility
    -FOMO_Simulator (iPhone 15) Configuration
    -Preview Data Management

#Swift Specific Rules
    -View Structure and Navigation
        -Use TabView for main navigation (Venues, My Passes, Profile)
        -Implement proper view hierarchy for each feature
        -Use NavigationStack for venue list and details
        -Use sheets for paywall and drink menu presentation
    -State Management
        -Use appropriate property wrappers:
        @StateObject for view models
        @State for local view state only
        @Binding for pass-through state
        @AppStorage for user preferences
        @Environment for dependency injection
    -Networking and Data Flow
        -Implement proper error handling for API calls
        -Use async/await for network requests
        -Handle loading states appropriately
        -Cache venue and drink data for better performance
    -Security Implementation
        -Secure storage of auth tokens in Keychain
        -Encrypt sensitive pass data
        -Implement proper session management
        -Handle token refresh logic
    -Payment Integration
        -Implement StoreKit 2 for payments
        -Handle payment state and errors
        -Validate purchases with backend
        -Store purchase receipts securely
    -Pass Management
        -Implement Core Data for pass storage
        -Handle pass expiration logic
        -Generate and display QR codes
        -Sync passes with backend
    -Drink Menu & Checkout
        -Handle drink selection state
        -Manage order processing
        -Implement checkout flow
        -Preview data integration
        -Order history tracking

#Preview Support
    -Debug Environment
        -FOMO_Simulator configuration
        -Preview data management
        -Mock service responses
    -Preview Assets
        -Sample venue data
        -Mock drink menus
        -Test user profiles
        -Preview passes

# Additional Best Practices
- **Version Control & Code Reviews**  
  - Use pull request templates to check code coverage, UI states, and documentation  
  - Adopt a clear branching strategy (e.g., GitFlow)  
  - Require at least one peer review before merging code to the main branch

- **Documentation & Knowledge Sharing**  
  - Maintain doc comments for complex functions and classes  
  - Keep a simple wiki or docs folder for architecture decisions and testing guidelines  
  - Provide onboarding docs to ensure consistent coding practices

# Migration Rules
- Validate @objc declarations
- Reject Sweetpad patterns
- Maintain iOS 17 compatibility while using iOS 18.1 features
