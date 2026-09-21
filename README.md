# Netflix Clone - Flutter Movie Discovery App

A high-performance, responsive Flutter application replicating the Netflix discovery experience. Built using Clean Architecture, BLoC State Management**, and Dio Network Client integrated with the TMDB (TheMovieDB) API.

---

 Architecture Overview

This project follows Clean Architecture principles to separate concerns into distinct, testable layers:

```
lib/
├── core/                   # Infrastructure & Cross-cutting Concerns
│   ├── config/             # Environment & API Configurations (ApiConfig)
│   ├── di/                 # Service Locator / Dependency Injection (GetIt)
│   ├── network/            # Network Layer (DioClient, ApiEndpoints)
│   └── utils/              # Utility Helpers (Debouncer)
├── data/                   # Data Layer
│   ├── datasources/        # Remote API Data Sources (TMDBApiService)
│   ├── models/             # Data Models & JSON Serialization (MovieModel, MovieResponse)
│   └── repositories/       # Repository Implementations (MovieRepositoryImpl)
├── presentation/           # UI & State Management Layer
│   ├── bloc/               # Business Logic Components (HomeBloc, SearchBloc, ComingSoonBloc)
│   ├── screens/            # Application Screen Views
│   └── widgets/            # Reusable UI Components (MovieCard, ShimmerLoading, ErrorView)
├── service/                # Application Services (NavigationServices)
└── theme/                  # Theme & Typography (ColorScheme, TextTheme)
```

---

## API-Driven vs. Mock Screens Breakdown

###  API-Driven Screens (Live TMDB API Integration)
1. **Home Screen (`HomeScreen`)**:
   - **Featured Banner**: Live high-resolution backdrop preview of trending movies.
   - **Movie Rails**: Fetches live data from TMDB endpoints (`/trending/movie/week`, `/movie/popular`, `/movie/now_playing`, `/movie/top_rated`).
   - **Previews Rail**: Horizontal circular rail showcasing top trending titles.
   - **Continue Watching Rail**: Interactive watch list with progress indicators and action menus.
   - **Pull-to-Refresh & Shimmer Loading**: Integrated shimmer skeleton placeholders while data loads.

2. **Search Screen (`SearchScreen`)**:
   - **Live Search & Debouncing**: Uses a custom 400ms debouncer to optimize TMDB API calls during query typing.
   - **Popular Searches**: Automatically populates popular movies list when search query is empty.
   - **3-Column Grid Layout**: Responsive movie poster grid for search results.
   - **Empty State Handling**: Custom empty search state view when no matching titles are found.

3. **Coming Soon Screen (`ComingSoonScreen`)**:
   - **New Arrivals List**: Infinite scroll feed backed by TMDB `/movie/upcoming` endpoint.
   - **Backdrop Cards**: 16:9 backdrop images with release dates, synopses, and genre tags.
   - **Interactive Actions**: Remind Me and Share action controls.

---

### Mock & Static Screens (Figma Pixel-Perfect UI)
1. **Splash & Profile Selection Screen (`SplashScreen` & `LogoScreen`)**:
   - Animated Netflix branding startup flow leading to "Who's Watching?" profile selection grid.

2. **Downloads Screen (`DownloadsScreen`)**:
   - Smart Downloads header, "Downloads For You" hero illustration, and setup action buttons.

3. **Movie Details View (`MovieDetailsScreen`)**:
   - Full-screen backdrop view with play overlay, release year, rating badge, synopsis, cast details, and recommended titles list.

4. **Profile & Settings Screen (`ProfileScreen`)**:
   - User profile avatars, "Tell Friends About Netflix" banner, social share icons (WhatsApp, Facebook, Gmail, More), and account settings navigation.

---

## Packages Used

| Package | Purpose |
| :--- | :--- |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | BLoC pattern for predictable state management across screens |
| [`dio`](https://pub.dev/packages/dio) | HTTP client with interceptors, logging, and automatic retry handling |
| [`get_it`](https://pub.dev/packages/get_it) | Service locator for dependency injection |
| [`cached_network_image`](https://pub.dev/packages/cached_network_image) | High-performance image caching with fallback placeholders |
| [`shimmer`](https://pub.dev/packages/shimmer) | Skeleton loading animations for asynchronous data fetching |
| [`equatable`](https://pub.dev/packages/equatable) | Value equality comparison for BLoC states and events |
| [`rxdart`](https://pub.dev/packages/rxdart) | Reactive extensions for debouncing search input streams |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | iOS style icon assets |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Local persistent storage |

---

## 🔑 Adding / Configuring the TMDB API Key

### How to Get a Free TMDB API Key
1. Register for a free account at [TheMovieDB (TMDB)](https://www.themoviedb.org/signup).
2. Go to your **Account Settings** → **API** (`https://www.themoviedb.org/settings/api`).
3. Click **Create** / **Request an API Key** and choose **Developer**.
4. Fill out the application details and accept terms.
5. Copy your **API Key (v3 auth)** (32-character key).

### Option 1: Command Line (`--dart-define`)
Run the app passing your API key directly:

```bash
flutter run --dart-define=TMDB_API_KEY=your_tmdb_api_key_here
```

### Option 2: Updating `api_config.dart`
Alternatively, you can set your default key in `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'a07e22bc18f5cb106bfe4cc1f83ad8ed',
  );
}
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.11.0`
- Dart SDK `>=3.11.0`

### Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/netflix_clone.git
   cd netflix_clone
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

4. **Run Automated Unit & Widget Tests**:
   ```bash
   flutter test
   ```

5. **Build Android Executable APK**:
   ```bash
   # Debug APK
   flutter build apk --debug

   # Release APK
   flutter build apk --release
   ```
