# Project Context

## Overview
- App: `resetmusic-ios-local`
- Platform: iOS, SwiftUI
- Style: feature-based folders with MVVM and lightweight clean architecture
- Networking: endpoint enum + service protocol/service + repository/view model
- Persistence:
  - `UserDefaultsManager` for lightweight local state
  - `KeychainManager` for auth token
- Playback: custom `PlayerViewModel` + audio engine + queue manager

## High-Level Structure
- `Album/`
  - album models, listing, detail, local cache, repository, view models
- `FeaturedArtist/`
  - artist models, detail, listing, local cache, repository, view models
- `Genre/`
  - genre listing, genre detail, genre songs flow
- `Auth/`
  - welcome, login, signup, forgot password, genre selection, auth repository/models
- `Networking/`
  - base config, generic network manager, endpoints, keychain, user defaults
- `Services/`
  - feature service protocols, real services, mocks
- `PlayerView/`
  - mini player, full player, queue, share sheet, playback models
- `Screens/`
  - root tab flow, drawer, home/search/artists/profile and shared screen-level UI

## Architecture Pattern
- UI layer:
  - SwiftUI views in feature folders
  - view-local state for presentation and interaction
- ViewModel layer:
  - `ObservableObject` + `@Published`
  - owns loading, error, pagination, screen actions
- Repository layer:
  - used where caching or orchestration is needed
  - examples: album and artist repositories
- Service layer:
  - direct API access using `NetworkManager`
  - protocol-first for preview/testing flexibility

## App Entry Flow
- App entry: `resetmusic_ios_localApp.swift`
- Main container: `ContentView.swift`
- Splash:
  - `SplashScreenView` overlays first
- Auth/app routing in `ContentView`
  - `welcome`
  - `login`
  - `signup`
  - `app`
- Main app shell after auth or browse-first:
  - `RootView`

## Root App Context
- `RootView.swift`
  - owns tab selection
  - owns profile drawer open/close state
  - hosts `RootView` navigation stacks per tab
  - hosts mini player and full player presentation
  - receives `currentUserName`
  - receives async `onLogout`
- Profile drawer:
  - `GuestModeDrawerView`
  - used as current side drawer for account/info actions

## Auth Context

### Auth Screens
- `Auth/WelcomeView.swift`
  - entry marketing/onboarding screen
  - CTA opens login/signup flow
  - secondary CTA enters app as browse-first
- `Auth/Login/LoginView.swift`
  - bound to `LoginViewModel`
  - calls login API
  - exposes `onCreateAccount`
  - exposes `onAuthenticated`
- `Auth/Signup/SignUpView.swift`
  - bound to `SignUpViewModel`
  - calls register API
  - exposes `onLogin`
  - exposes `onAuthenticated`

### Auth Models
- `Auth/Models/AuthUser.swift`
  - normalized auth user model
  - supports `_id` decoding
  - persisted to `UserDefaults`
- `Auth/Models/AuthResponse.swift`
  - login/register response model
  - includes `user`, `token`, `message`
- `AuthActionResponse`
  - used for logout response

### Auth Networking
- `Networking/Endpoints/AuthEndpoint.swift`
  - `POST /api/users/register`
  - `POST /api/users/login`
  - `POST /api/users/logout`
- `Services/Protocols/AuthServiceProtocol.swift`
  - `register`
  - `login`
  - `logout`
- `Services/AuthService.swift`
  - real API implementation using `NetworkManager`

### Auth Repository
- `Auth/AuthRepository.swift`
  - auth use-case contract
- `Auth/AuthRepositoryImpl.swift`
  - saves token to keychain on login/register
  - saves user to user defaults on login/register
  - logout calls API when token exists
  - always clears token and current user locally on logout

### Auth State Persistence
- `Networking/KeychainManager.swift`
  - stores auth token securely
  - `saveAuthToken`
  - `loadAuthToken`
  - `clearAuthToken`
- `Networking/UserDefaultsManager.swift`
  - stores:
    - last player track
    - current auth user

### Auth View Models
- `Auth/Login/LoginViewModel.swift`
  - fields:
    - `email`
    - `password`
    - `isLoading`
    - `errorMessage`
    - `successMessage`
  - validates basic input
  - calls repository login
- `Auth/Signup/SignUpViewModel.swift`
  - fields:
    - `name`
    - `email`
    - `password`
    - `isLoading`
    - `errorMessage`
    - `successMessage`
  - validates basic input
  - calls repository register

### Auth Runtime Flow
- App launch:
  - `ContentView` checks keychain for stored token
  - if token exists, routes directly to `app`
- Login success:
  - token saved to keychain
  - user saved to user defaults
  - `ContentView` transitions to `RootView`
- Signup success:
  - token saved to keychain
  - user saved to user defaults
  - `ContentView` transitions to `RootView`
- Logout:
  - initiated from `GuestModeDrawerView`
  - `RootView` forwards callback to `ContentView`
  - repository calls `/api/users/logout`
  - local token and saved user are cleared
  - app returns to `WelcomeView`

## Drawer Context
- File: `Screens/ProfileScreen/GuestModeDrawerView.swift`
- Current behavior:
  - shows logged-in user name from `ContentView`
  - contains external links
  - contains logout action
- Tappability note:
  - rows use full-width hit shapes
  - links were changed to `Link` for better device behavior

## Player Context
- `PlayerViewModel`
  - current track
  - queue
  - playback state
  - progress
  - repeat/shuffle
- Full player:
  - `FullPlayerView`
- More sheet:
  - `PlayerMoreSheetView`
  - parent screens own artist navigation
- Mini player:
  - `StickyPlayerBar`

## Navigation Notes
- Full-player artist navigation is delegated upward to parent stack
- Album and genre track-row more sheets use parent `navigationDestination`
- Artist re-entry from album/genre tracks pushes `ArtistLoaderView`

## Album Context
- `AlbumDetailView`
  - loads songs
  - hydrates missing album detail when needed
  - owns track more-sheet presentation
- `AlbumDetailViewModel`
  - fetches songs
  - fetches full album detail if incoming model is partial
- `AlbumRepositoryImpl`
  - local cache + background refresh

## Artist Context
- `ArtistDetailView`
  - loads artist albums
  - can push album detail
- `ArtistLoaderView`
  - fetches full artist by id before showing `ArtistDetailView`
- `ArtistRepositoryImpl`
  - local cache + background refresh

## Genre Context
- `GenreDetailView`
  - owns genre track list
  - owns track more-sheet presentation
  - pushes artist screen from track row actions

## Important Shared Utilities
- `NetworkManager`
  - generic async request layer
  - applies bearer token only when endpoint requires auth
- `APIConfig`
  - base URL
- `APIError`
  - shared network error mapping

## Current Auth-Related Files
- `Auth/AuthRepository.swift`
- `Auth/AuthRepositoryImpl.swift`
- `Auth/Models/AuthUser.swift`
- `Auth/Models/AuthResponse.swift`
- `Auth/Login/LoginView.swift`
- `Auth/Login/LoginViewModel.swift`
- `Auth/Signup/SignUpView.swift`
- `Auth/Signup/SignUpViewModel.swift`
- `Auth/WelcomeView.swift`
- `Networking/Endpoints/AuthEndpoint.swift`
- `Networking/KeychainManager.swift`
- `Networking/UserDefaultsManager.swift`
- `Services/AuthService.swift`
- `Services/Protocols/AuthServiceProtocol.swift`

## Known Scope Decisions
- Auth is currently email/password only
- Google auth button is UI-only placeholder
- Forgot password screen is UI-only placeholder
- Auth token existence is used as logged-in check
- No refresh-token/session-refresh flow exists yet

## Recommended Future Extensions
- Add dedicated auth/session coordinator object
- Add secure persisted auth state observable for the whole app
- Add logout error surface if server logout fails
- Add token expiry handling
- Add authenticated user profile endpoint sync
- Add tests for auth repository and auth view models
