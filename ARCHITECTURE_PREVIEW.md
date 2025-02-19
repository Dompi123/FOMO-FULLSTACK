# FOMO iOS Architecture Overview

## Project Structure
```mermaid
graph TD
    A[FOMO_FINAL] --> B[Features]
    A --> C[Core]
    A --> D[Preview Content]
    
    B --> E[Venues]
    B --> F[Drinks]
    B --> G[Passes]
    B --> H[Profile]
    
    E --> I[Views]
    E --> J[ViewModels]
    I --> K[VenueListView]
    I --> L[VenueDetailView]
    I --> M[PaywallView]
    
    F --> N[DrinkMenuView]
    F --> O[CheckoutView]
    
    C --> P[Models]
    C --> Q[Payment]
    C --> R[Navigation]
    
    D --> S[PreviewData]
    D --> T[Assets]
    
    Q --> U[TokenizationService]
    Q --> V[PaymentManager]
    
    P --> W[Venue]
    P --> X[Pass]
    P --> Y[UserProfile]
    P --> Z[DrinkOrder]
```

## Data Flow
```mermaid
graph LR
    A[ViewModels] --> B[Preview Data]
    A --> C[Models]
    B --> D[Mock Services]
    C --> E[Core Services]
    E --> F[Preview Environment]
```

## Preview System
```mermaid
journey
    title Preview Data Flow
    section Setup
        Initialize Preview Data: 5: PreviewDataLoader
        Load Mock Services: 5: MockTokenizationService
    section Runtime
        Load Venues: 3: VenueListViewModel
        Load Profile: 3: ProfileViewModel
        Load Passes: 3: PassesViewModel
    section Validation
        Verify Assets: 5: validate_preview_paths.sh
        Check iOS 18.1: 5: validate_ios17_simulator.sh
```

## Feature Dependencies
```mermaid
graph TD
    A[ContentView] --> B[VenueListView]
    A --> C[PassesView]
    A --> D[ProfileView]
    B --> E[VenueDetailView]
    E --> F[PaywallView]
    E --> G[DrinkMenuView]
    G --> H[CheckoutView]
```

## Build Pipeline
```mermaid
journey
    title Build Process
    section Reset
        Nuclear Reset: 5: nuclear_reset.sh
    section Generate
        XcodeGen: 5: xcodegen
        Preview Data: 4: setup_preview.sh
    section Build
        Compile: 5: xcodebuild
        Validate: 4: final_validation.sh
```

## Preview Commands
```bash
# Run to refresh preview
cursor docs preview ARCHITECTURE_PREVIEW.md --live

# Validate preview setup
./scripts/validate_preview_paths.sh

# Reset and rebuild
./scripts/nuclear_reset.sh && xcodegen generate
```

## Key Components

### Core Services
- PaymentManager: Handles payment processing and tokenization
- StorageManager: Manages data persistence
- PreviewNavigationCoordinator: Coordinates navigation in preview mode

### Preview Integration
- PreviewDataLoader: Loads mock data for previews
- MockTokenizationService: Simulates payment processing
- Preview environment keys for configuration

### Feature Modules
- Venues: Browse and view venue details
- Passes: Manage digital passes
- Profile: User preferences and settings
- Drinks: Menu browsing and ordering

### Build System
- XcodeGen for project generation
- Validation scripts for preview data
- iOS 18.1 simulator configuration 