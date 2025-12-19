# MiniCheckout App

## SwiftUI Demo – Supermarket Checkout Flow

A **SwiftUI demo app** that simulates a supermarket checkout experience.  
Users can browse products, add items to a cart, and complete a mock payment flow with a wallet balance.

---

## Features

### Product List
- Products loaded from a local JSON file
- Prices modeled in **JPY**

### Cart
- Add, remove, and adjust item quantities
- Persistent cart state using `UserDefaults`

### Checkout Flow
- Simulated payment API
- Loading, success, and failure states
- Order snapshot preserved after payment confirmation

### Wallet Balance
- Wallet balance shown
- Balance deducted on successful checkout

### Error & Loading States
- User-friendly error messages

### Unit Tests
- Wallet balance logic
- Checkout success and failure paths

---

## Architecture

### SwiftUI + MVVM
- Views are declarative and stateless
- ViewModels manage async logic and UI state

### Shared State
- `CartStore` and `WalletStore` implemented using `@Observable`
- Injected via SwiftUI `@Environment`

### Networking
- `ProductAPI` and `CheckoutAPI` protocols
- Local JSON and simulated checkout implementations
- Mock APIs for deterministic testing

---

## Design Decisions

### Money Representation
- All prices and totals are modeled as `Int` values representing **JPY**

### Checkout Snapshot
- Order summary is rendered from a snapshot captured at payment time
- Ensures receipt details remain visible after the cart is cleared

### Test Isolation
- Tests use isolated `UserDefaults` suites
- No shared global state between test cases

---

## Requirements

- **Xcode:** 16+
- **iOS:** 18+
- **Language:** Swift (SwiftUI)

---

## Running the App

1. Clone the repository
2. Open `MiniCheckout.xcodeproj` in Xcode
3. Select an iOS simulator
4. Build and run (`Cmd + R`)

## Notes

This project was built as a take-home assignment to demonstrate:
- SwiftUI architecture
- Async handling and state management
- Local persistence
- Separation of concerns
- Edge-case handling and testing
