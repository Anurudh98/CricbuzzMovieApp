# MovieApp (TMDb)

A simple iOS app built with **SwiftUI** that integrates with **The Movie Database (TMDb)** API. It lists popular movies, shows detailed information, plays trailers, supports search, and lets users favorite movies.

---

## Features

- **Popular Movies List (Home)** — shows each movie's poster, title, rating and release year in a paginated, infinite-scrolling list.
- **Movie Detail** — trailer player, title, plot, genres, cast, duration and rating.
- **Trailer Playback** — plays the YouTube trailer inline using a `WKWebView` (YouTube IFrame Player API), with a "Watch on YouTube" fallback if a video can't be embedded.
- **Search** — a search bar on the Home screen to find movies by title (debounced live search).
- **Favorites** — mark/unmark favorites from both the list and detail screens. Favorites are persisted and restored on relaunch, and are visually indicated with a filled heart. A heart toggle in the navigation bar filters the Home list to show only favorites.

---

## Requirements

- Xcode 26 (or newer)
- iOS 17+ device or simulator (the app uses the SwiftUI `@Observable` macro)
- A TMDb API key

---

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Anurudh98/CricbuzzMovieApp.git
   cd CricbuzzMovieApp
   ```

2. **Open the project**
   ```bash
   open MovieApp.xcodeproj
   ```

3. **TMDb API key**
   The app reads its API key from a single place: `MovieApp/Config/APIConfiguration.swift`.
   ```swift
   enum APIConfiguration {
       static let apiKey = "YOUR_TMDB_API_KEY"
       ...
   }
   ```
   A working key is already included so the app runs out of the box. To use your own key, get one for free from https://www.themoviedb.org/settings/api and replace the value.

4. **Build & run**
   - Select the **MovieApp** scheme and an iOS Simulator (or a connected device).
   - Press **Cmd + R** to build and run.

### Dependencies
- **None.** The project uses only Apple frameworks (`SwiftUI`, `Foundation`, `WebKit`). There is no CocoaPods/SPM setup required.

---

## Architecture

The app follows a lightweight **MVVM + Repository** pattern:

```
View (SwiftUI)  →  ViewModel (@Observable)  →  Repository  →  APIClient (URLSession)  →  TMDb
```

- **View** — SwiftUI screens (`MovieListView`, `MovieDetailView`) and reusable components.
- **ViewModel** — `MovieListViewModel`, `MovieDetailViewModel` hold UI state and call the repository (async/await).
- **Repository** — `MovieRepository` maps TMDb responses into domain models.
- **Networking** — `APIClient` (generic, `URLSession`-based) + `Endpoint` builder.
- **Manager** — `FavoritesManager` persists favorites to `UserDefaults`.
- **Dependency container** — `AppDependencies` wires everything together and is injected via the SwiftUI environment.

### TMDb endpoints used
| Feature | Endpoint |
|---|---|
| Popular movies | `/movie/popular` |
| Movie details + cast | `/movie/{id}?append_to_response=credits` |
| Trailers | `/movie/{id}/videos` |
| Search | `/search/movie?query={query}` |

> Note: the cast is fetched via `append_to_response=credits` on the details request, so no extra endpoint is needed.

---

## Assumptions

- The provided TMDb API key is used directly for simplicity (see "Known limitations").
- "Duration" on the Home list is represented by the release year, since the popular list endpoint doesn't return runtime; the full runtime (e.g. `2h 19m`) is shown on the Detail screen where it is available.
- The "best" trailer is chosen automatically: an official YouTube trailer is preferred, then any YouTube trailer, then any embeddable YouTube video.
- Favorites are stored locally per device using `UserDefaults` (no account/cloud sync).
- Search matches movie titles via the TMDb search endpoint; when the favorites filter is on, search filters the favorites list locally.

---

## Known limitations

- **API key in source** — the key is hard-coded in `APIConfiguration.swift` for easy running. In production it should be injected via an `.xcconfig`/build setting or the keychain, not committed.
- **No unit tests** — the architecture is protocol-based and testable (mockable `APIClientProtocol` / `MovieRepositoryProtocol`), but automated tests are not included due to the assignment's time constraints.
- **Favorites are device-local** — they are not synced across devices or reinstalls.

---

## Project structure

```
MovieApp/
├── App/                # AppDependencies (composition root)
├── Config/             # APIConfiguration (API key, base URLs)
├── Manager/            # FavoritesManager (UserDefaults persistence)
├── Model/              # Movie, MovieDetail, CastMember, Video, Genre, PagedResponse
├── Networking/         # APIClient, Endpoint, NetworkError, protocols
├── Repository/         # MovieRepository (+ protocol)
├── ViewModel/          # MovieListViewModel, MovieDetailViewModel
└── View/
    ├── Home/           # MovieListView, MovieRowView
    ├── Detail/         # MovieDetailView, TrailerPlayerView, CastCardView
    └── Components/      # FavoriteButton, RatingBadge, RemoteImageView, StateViews
```
