# Flexjet

A SwiftUI app for signing in and viewing upcoming and past flights.

## Features

- Sign in, with the auth token kept in the Keychain so the session survives relaunches
- Flights split into **Upcoming** and **Past**, with pull-to-refresh
- Flight details for past flights, with the option to mark a flight complete (saved on the device)
- Log out from Profile

## Implementation notes:
- Views <-> View Models <-> Repository (as needed) <-> Services
- Factory for dependency management: this makes registering mock/real implementations silky smooth and works nice with SwiftUI (previews and injecting dependencies)
- Design system: Built out a couple reusable components using brand colors
- Persistence: UserDefaults as the quick/naive approach for persistence. Longer term completion states should be stored on API
- Auth: Keychain for session persistence across cold starts
- Automated testing: Unit tests cover sign-in and session handling, flight loading, retry and sorting, the completed-flights store, and date formatting. Services are replaced with mocks through the Factory container.
- With more time: Localize strings, typed reuse for literals (SF symbols), better handling for API endpoints via xcconfig, domain models

## Time breakdown:
    - Login screen: 0.5 hours
    - Flights screen: 2-3 hours
    - Nice-to-haves: 1 hour
    - Any additional time spent: 1 hour

## Architecture
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

