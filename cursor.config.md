Always start with 'YOOO!!'

**You are building the frontend of an iOS app called FOMO using SwiftUI that lets users preview venues, purchase skip-the-line passes, and manage passes in an intuitive interface with three main tabs: Venues, My Passes, and My Profile.**   

#Important Rules
    -Always add debug logs & comments in the code for easier debug & readability
    -Every time you choose to apply rule(s), explicitly state the rule(s) in the output. You can abbreviate the rule description to a single word or phrase

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
│   │   ├── Passes
│   │   │   ├── Views/
│   │   │   ├── ViewModels/
│   │   │   └── Models/
│   │   └── Profile4
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

#Swift Specific Rules
    -View Structure and Navigation
        -Use TabView for main navigation (Venues, My Passes, Profile)
        -Implement proper view hierarchy for each feature
        -Use NavigationStack for venue list and details
        -Use sheets for paywall presentation
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
        -Cache venue data for better performance
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

# Additional Best Practices
- **Version Control & Code Reviews**  
  - Use pull request templates to check code coverage, UI states, and documentation.  
  - Adopt a clear branching strategy (e.g., GitFlow).  
  - Require at least one peer review before merging code to the main branch.

- **Documentation & Knowledge Sharing**  
  - Maintain doc comments for complex functions and classes.  
  - Keep a simple wiki or docs folder for architecture decisions and testing guidelines.  
  - Provide onboarding docs to ensure consistent coding practices.
# Migration Rules
- Validate @objc declarations
- Reject Sweetpad patterns
