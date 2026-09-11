# Flexjet

A SwiftUI app for signing in and viewing upcoming and past flights.

## Features

- Sign in, with the auth token kept in the Keychain so the session survives relaunches
- Flights split into **Upcoming** and **Past**, with pull-to-refresh
- Flight details for past flights, with the option to mark a flight complete (saved on the device)
- Log out from Profile

## Requirements

- Xcode 26+
- iOS 26.0+
- [Factory](https://github.com/hmlongco/Factory) (added through Swift Package Manager)

## Getting Started

1. Open `flexjet.xcodeproj`. Xcode resolves the package dependency automatically.
2. Build and run the `flexjet` scheme (⌘R).
3. Sign in with the test credentials from the assignment brief.

## Architecture

MVVM with SwiftUI. Dependencies are provided by a Factory container.

```
View ─▶ ViewModel ─▶ Repository / Service ─▶ NetworkService ─▶ API
                                          └▶ KeychainService
```

- **Services** (`Auth`, `Flights`, `Networking`, `Keychain`) sit behind protocols, so they can be swapped for test doubles.
- **`AuthRepository`** publishes the auth token. `RootView` watches it to decide between the login screen and the main tabs, so there's no manual navigation on sign-in or sign-out.
- **`CompletedFlightsStore`** saves completed flight IDs in `UserDefaults`.
- **Design System** holds shared components (`FlexButton`, `AirplaneProgress`) and the brand colors.

```
flexjet/
├── APIModels/       Request and response types
├── Design System/   Reusable UI components
├── Extensions/      DI container, formatting helpers
├── Flights/         Flights list and details
├── Login/           Sign-in
├── Persistence/     Local storage
├── Profile/         Account and log out
├── Repositories/    Auth state
└── Services/        Networking, auth, flights, keychain
```

## Testing

Unit tests cover flight loading and sorting, the completed-flights store, and date formatting. Run them with ⌘U.
