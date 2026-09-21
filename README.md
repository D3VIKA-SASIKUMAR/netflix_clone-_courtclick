# Netflix Clone

A Netflix Movie Discovery Flutter application featuring clean architecture, BLoC state management, Dio API integration with TMDB, and responsive UI screens.

## Features

- **Home Screen**: Dynamic movie rails, featured movie backdrop banner, top 10 previews rail, and continue watching list.
- **Search Screen**: Instant search with debouncing (~400ms), popular searches list, and empty state views.
- **Coming Soon Screen**: Upcoming movie list with infinite pagination support and reminder actions.
- **Downloads Screen**: Downloads overview screen matching Netflix UI layout.
- **Profile Screen**: User profiles, social sharing links, and settings list.
- **Movie Details**: Full movie details view with backdrop preview, rating, release year, overview, and cast recommendations.

## Tech Stack & Architecture

- **Flutter**: Sound Null Safety
- **State Management**: `flutter_bloc`
- **Networking**: `dio` with interceptors and error logging
- **Dependency Injection**: `get_it`
- **UI Components**: `cached_network_image`, `shimmer`

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.0

### Running the App

```bash
flutter pub get
flutter run
```

### Running Tests

```bash
flutter test
```

### Building APK

```bash
flutter build apk --debug
```
# netflix_clone-_courtclick
