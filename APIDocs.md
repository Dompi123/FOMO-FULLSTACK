# Payment Module API Documentation

## Overview
The Payment module provides a complete payment processing flow with card validation and tokenization capabilities.

## Components

### PaymentGatewayView
A SwiftUI view that presents a user interface for collecting and processing payment information.

#### Usage
```swift
PaymentGatewayView()
    .environment(\.tokenizationService, yourTokenizationService)
```

#### Features
- Card number input with validation
- Expiry date input with validation
- CVC input with validation
- Loading state during processing
- Error handling and success feedback

### PaymentViewModel
The view model handling payment logic and validation.

#### Properties
- `cardNumber: String` - The credit card number
- `expiry: String` - The card expiry date (MM/YY format)
- `cvc: String` - The card verification code
- `isProcessing: Bool` - Indicates if a payment is being processed
- `isValid: Bool` - Indicates if all inputs are valid

#### Validation Rules
- Card Number: 16-19 digits, spaces allowed
- Expiry Date: MM/YY format, must be future date
- CVC: 3 digits

### TokenizationService
A protocol defining the interface for payment tokenization.

#### Protocol Definition
```swift
protocol TokenizationService {
    func tokenize(cardNumber: String, expiry: String, cvc: String) async throws -> String
}
```

#### Mock Implementation
A `MockTokenizationService` is provided for testing and preview purposes.

## Integration Guide

### Setting up the Payment Flow
1. Create an instance of PaymentGatewayView
2. Provide a TokenizationService implementation
3. Present the view modally or in a navigation stack

Example:
```swift
struct ContentView: View {
    @State private var showPayment = false
    
    var body: some View {
        Button("Pay") {
            showPayment = true
        }
        .sheet(isPresented: $showPayment) {
            PaymentGatewayView()
                .environment(\.tokenizationService, YourTokenizationService())
        }
    }
}
```

### Backend Integration
The tokenization service should communicate with your backend using the following format:

Request:
```json
{
    "card_number": "4111111111111111",
    "expiry_month": "12",
    "expiry_year": "25",
    "cvc": "123"
}
```

Response:
```json
{
    "token": "tok_test_123456789",
    "expiry": "12/25",
    "last4": "1111"
}
```

## Testing
The module includes comprehensive test coverage for:
- Input validation
- Edge cases
- UI state management
- Payment processing flow

Run tests using:
```bash
./scripts/add_validation_tests.sh
``` 