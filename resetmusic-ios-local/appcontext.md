# Full App Context

## 1. Project Identity
- App name: `resetmusic-ios-local`
- Platform: iOS
- UI framework: SwiftUI
- Media stack: `AVPlayer` through a custom engine
- Image loading: `Kingfisher`
- Auth storage: `KeychainManager`
- Local lightweight persistence: `UserDefaultsManager`
- Networking style: custom `NetworkManager` + endpoint enums

## 2. Overall Architecture
- The app follows a practical MVVM + clean-ish architecture.
- Main layers used across features:
  - `View`
  - `ViewModel`
  - `Repository` where caching/orchestration is needed
  - `Service` for direct API calls
  - `Endpoint` enum for route definitions
  - `Model` for decoding/encoding API responses
- Not every feature has every layer.
- Simpler features use `View -> ViewModel -> Service`.
- Features with caching use `View -> ViewModel -> Repository -> Service -> NetworkManager`.

## 3. Folder-Level Mental Model
- `Album/`
  - album list, album detail, album models, album cache, album repository
- `FeaturedArtist/`
  - artist list, artist detail, artist cache, artist repository
- `Genre/`
  - genre list and genre detail flows
- `Auth/`
  - welcome, login, signup, forgot password, auth repository, auth models
- `Networking/`
  - network client, config, endpoint definitions, local persistence helpers
- `Services/`
  - service protocols, real API services, mocks
- `PlayerView/`
  - mini player, full player, queue, share, playback state, queue engine
- `Screens/`
  - root shell, tab flow, drawer, search, artists, home, shared screen composition

## 4. App Entry and Runtime Boot
- Entry file: `resetmusic_ios_localApp.swift`
- At launch:
  - app configures `AudioSessionManager.shared`
  - app forces a black window background to avoid launch-to-first-frame white flash
  - app overlays `SplashScreenView`
- Main root inside the app entry:
  - `ContentView()`
- `ContentView` is the top-level auth/app router.

## 5. Auth Routing Flow
- `ContentView.swift` owns the top-level screen state:
  - `welcome`
  - `login`
  - `signup`
  - `forgotPassword`
  - `app`
- Flow behavior:
  - first screen is `WelcomeView`
  - `WelcomeView` can open login/signup flow
  - browse-first enters the app without auth
  - login success enters the app
  - signup success enters the app
  - forgot-password is routed from login
  - logout returns the app to welcome
- On startup, `ContentView` checks the keychain for a stored token.
- If a token exists, the app skips onboarding and opens the main app shell.

## 6. Auth Architecture
- Auth uses:
  - `AuthEndpoint`
  - `AuthServiceProtocol`
  - `AuthService`
  - `AuthRepository`
  - `AuthRepositoryImpl`
  - `LoginViewModel`
  - `SignUpViewModel`
  - `ForgotPasswordViewModel`
- This is a clean path:
  - UI does not call `NetworkManager` directly.
  - View models talk to repository.
  - Repository talks to service.
  - Service talks to `NetworkManager`.

## 7. Auth Endpoints Currently Wired
- `POST /api/users/register`
- `POST /api/users/login`
- `POST /api/users/logout`
- `POST /api/users/forgot-password`
- These are defined in `Networking/Endpoints/AuthEndpoint.swift`.

## 8. Auth Models
- `AuthResponse`
  - contains `user`, `token`, `message`
- `AuthActionResponse`
  - contains action response message
- `AuthUser`
  - normalized auth user model
  - decodes `_id`
  - supports encode/decode for user persistence

## 9. How Auth Is Stored
- Token storage:
  - `Networking/KeychainManager.swift`
  - methods:
    - `saveAuthToken`
    - `loadAuthToken`
    - `clearAuthToken`
- User storage:
  - `Networking/UserDefaultsManager.swift`
  - methods:
    - `saveCurrentUser`
    - `loadCurrentUser`
    - `clearCurrentUser`
- AuthRepository behavior:
  - on register:
    - saves token to keychain
    - saves user to user defaults
  - on login:
    - saves token to keychain
    - saves user to user defaults
  - on logout:
    - calls backend logout if token exists
    - clears token locally
    - clears current user locally

## 10. Auth ViewModel Behavior
- `LoginViewModel`
  - local input state:
    - `email`
    - `password`
  - UI state:
    - `isLoading`
    - `errorMessage`
    - `successMessage`
  - validates minimal input before calling API
- `SignUpViewModel`
  - local input state:
    - `name`
    - `email`
    - `password`
  - UI state:
    - `isLoading`
    - `errorMessage`
    - `successMessage`
  - validates minimal input before calling API
- Both return `Bool` success from async action methods so the views can route after completion.

## 11. Auth UI Flow
- `WelcomeView`
  - onboarding/marketing entry screen
  - has login/signup CTA
  - has browse-first CTA
- `LoginView`
  - bound to `LoginViewModel`
  - calls `onAuthenticated` on success
  - routes to create-account and forgot-password
- `SignUpView`
  - bound to `SignUpViewModel`
  - calls `onAuthenticated` on success
  - routes back to login
- `ForgotPasswordView`
  - uses its own request/view model setup

## 12. Root App Shell
- Main app shell is `RootView.swift`.
- `RootView` owns:
  - selected tab
  - profile drawer open state
  - home navigation path
  - full-player presentation
- Tabs currently active:
  - home
  - artists
  - search
- The profile drawer is rendered from `RootView`.

## 13. Important State Management Notes
- State management is a mix of:
  - `@State`
  - `@StateObject`
  - `@EnvironmentObject`
  - `@Published`
  - `NotificationCenter` observers
  - `Combine` publishers
- Screen-local presentation state lives in views.
- Feature/business state lives in view models.
- Shared playback state lives in `PlayerViewModel`.
- Cache refreshes for albums/artists propagate through `NotificationCenter`.

## 14. Important Player Architecture
- Player stack is split clearly:
  - `PlayerViewModel`
  - `PlayerAudioEngine`
  - `PlayerQueueManager`
  - UI views under `PlayerView/`
- `PlayerViewModel`
  - owns user-facing playback state
  - owns current queue as UI tracks
  - bridges audio engine to SwiftUI
- `PlayerAudioEngine`
  - owns `AVPlayer`
  - handles load, play, pause, seek, periodic progress, preview limits
- `PlayerQueueManager`
  - owns logical queue of `Song`
  - owns index, shuffle state, persisted fallback queue IDs

## 15. Sticky Player Bar Persistence After Relaunch
- The sticky bar survives relaunch because playback state is persisted to user defaults.
- Persistence model: `PlayerView/Models/PersistedTrack.swift`
- Persisted values include:
  - track title
  - artist name
  - artist id
  - cover image
  - song id
  - preview state
  - progress fraction
  - duration
  - queue ids
  - queue index
  - full queue songs
- Persistence write path:
  - `PlayerAudioEngine` emits progress ticks
  - `PlayerViewModel.onProgressTick` calls `persistCurrentState`
  - `UserDefaultsManager.saveLastTrack` writes the encoded model
- Persistence restore path:
  - `PlayerViewModel.init` loads `PersistedTrack`
  - restores `currentTrack`, progress, duration
  - restores queue state into `PlayerQueueManager`
  - hydrates artist info from queue song objects
- Resume path:
  - `resumeIfNeeded()` fetches stream again from backend
  - restores queue
  - reloads player with restore progress
  - seeks to saved position when ready
- Sticky UI path:
  - `RootView` shows `StickyPlayerBar` whenever `playerVM.currentTrack != nil`

## 16. Queue System Logic
- Queue logic lives in `PlayerQueueManager.swift`.
- Queue manager stores:
  - real queue of `Song`
  - current index
  - shuffle flag
  - original unshuffled queue
  - persisted fallback queue ids
  - persisted fallback queue index
- Main behaviors:
  - `set(queue:playingSong:)`
    - sets active queue and index
  - `toggleShuffle()`
    - preserves current song
    - shuffles remaining songs
    - can revert to original order
  - `next()`
    - returns either full `Song` or persisted `songId`
  - `previous()`
    - same dual-path logic
  - `restartQueue()`
    - resets to first item
  - `selectSong(withId:)`
    - repositions queue to a chosen song
- Queue step abstraction:
  - `QueueStep.song(Song)`
  - `QueueStep.songId(String)`
- This is what allows queue recovery even if only ids survive.

## 17. Full Player and Mini Player Relationship
- Mini player:
  - `StickyPlayerBar`
  - visible when `currentTrack` exists
  - opens full player on tap
- Full player:
  - `FullPlayerView`
  - shown with `fullScreenCover`
  - can navigate to artists through callback delegation
- More sheet:
  - `PlayerMoreSheetView`
  - parent views own navigation behavior
- Queue sheet:
  - `QueueSheetView`
  - uses `PlayerTrack` UI models

## 18. Playback Flow
- Track play starts in screen-level UI such as album/genre/search/queue.
- UI calls `PlayerViewModel.play(song:queue:)`
- `PlayerViewModel`:
  - sets queue in `PlayerQueueManager`
  - maps queue to `PlayerTrack` UI models
  - sets `currentTrack`
  - fetches stream from `PlayerService`
  - hands URL to `PlayerAudioEngine`
- `PlayerAudioEngine`:
  - creates `AVPlayerItem`
  - creates `AVPlayer`
  - observes playback progress
  - enforces preview 30-second cap
  - notifies `PlayerViewModel` on finish and tick

## 19. How Call Interruption Is Handled
- There are two interruption-related layers:
  - `AudioSessionManager`
  - `PlayerViewModel`
- `AudioSessionManager`
  - configures `AVAudioSession`
  - observes:
    - `AVAudioSession.interruptionNotification`
    - `AVAudioSession.routeChangeNotification`
  - forwards events to `PlayerViewModel`
- `PlayerViewModel`
  - on interruption began:
    - sets `isInterrupted = true`
    - pauses the engine if playing
  - on interruption ended:
    - checks `shouldResume`
    - reactivates audio session
    - waits briefly
    - resumes playback
    - falls back to a recovery activation path if needed
  - on headphones unplugged:
    - pauses playback
- There is also direct observer setup inside `PlayerViewModel` itself for interruption and route change notifications.
- So interruption handling is currently duplicated in:
  - `AudioSessionManager`
  - `PlayerViewModel`
- Functional outcome:
  - incoming calls pause playback
  - calls can resume playback when the system allows it
  - unplugging headphones pauses playback

## 20. Device Switch / Route Change Detection
- Route/device change handling is implemented through:
  - `AVAudioSession.routeChangeNotification`
- Logic is in:
  - `AudioSessionManager.handleRouteChange`
  - `PlayerViewModel.handleRouteChange`
- Current handled cases:
  - `oldDeviceUnavailable`
    - interpreted as headphones unplugged
    - pauses playback
  - `newDeviceAvailable`
    - logs headphones plugged in
- This is the current “device switch and detection” layer in the app.

## 21. Audio Session Configuration
- `AudioSessionManager.configure()` sets:
  - category: `.playAndRecord`
  - mode: `.default`
  - options:
    - `.mixWithOthers`
    - `.allowBluetooth`
    - `.defaultToSpeaker`
- This is done on app init in `resetmusic_ios_localApp`.

## 22. Search Architecture
- Search is split into two flows:
  - global search screen
  - artist search inside artist listing flow

## 23. Global Search Flow
- UI:
  - `Screens/SearchScreen/SearchScreen.swift`
- ViewModel:
  - `Screens/SearchScreen/SearchViewModel.swift`
- Service:
  - `Services/SearchService.swift`
- Protocol:
  - `Services/Protocols/SearchServiceProtocol.swift`
- Endpoint:
  - `Networking/Endpoints/SearchEndpoint.swift`
- API route:
  - `GET /api/search?q=...`
- SearchScreen behavior:
  - local `searchText`
  - debounced with a `Task` and `350ms` delay
  - cancels previous task when input changes
  - clears results when query is empty
- Search results include:
  - artists
  - songs
  - albums
- Search navigates:
  - artists -> `ArtistLoaderView`
  - albums -> `AlbumDetailView`
  - songs -> `TrackRow` playback

## 24. Artist Search Flow
- Artist list screen uses `ArtistViewModel.searchArtists(query:)`
- Service route:
  - `GET /api/search/artists?q=...&page=...&limit=...`
- This is separate from the global multi-entity search.

## 25. Networking Architecture
- Shared network client:
  - `Networking/Client/NetworkManager.swift`
- Endpoint protocol:
  - `path`
  - `method`
  - `body`
  - `requiresAuth`
- Request flow:
  - build URL from `APIConfig.baseURL + endpoint.path`
  - set HTTP method
  - set `Content-Type: application/json`
  - inject bearer token only when `requiresAuth == true`
  - decode generic `Decodable` response
- Error handling:
  - non-2xx becomes `APIError.serverError(message)`
  - decode failure becomes `APIError.decodingError`

## 26. Repository Usage Across Features
- Albums:
  - use repository with local cache
- Artists:
  - use repository with local cache
- Auth:
  - uses repository for token/user persistence
- Search:
  - currently service-first without repository
- Genres:
  - mostly service/view model pattern

## 27. Cache Refresh Pattern
- Album and artist repositories use local data sources and background refresh.
- Pattern:
  - page 1 prefers cached data
  - repository refreshes network data in background
  - repository posts refresh notification
  - view model listens and updates UI
- This is used in:
  - `AlbumRepositoryImpl`
  - `ArtistRepositoryImpl`

## 28. Album Feature Context
- Album detail uses:
  - `AlbumDetailView`
  - `AlbumDetailViewModel`
- Album detail behavior:
  - loads track list by album id
  - paginates tracks
  - can retry failed load
  - can show track-level more sheet
  - can navigate to artist
- Important enhancement already present:
  - detail screen can hydrate missing album fields from `/api/albums/{id}`
  - this fixes “partial album model from another screen” issues

## 29. Artist Feature Context
- Artist listing:
  - `ArtistViewModel`
  - repository-backed
- Artist detail:
  - `ArtistDetailView`
  - `ArtistAlbumViewModel`
- Loader:
  - `ArtistLoaderView`
  - fetches full artist before presenting detail when only id/name is known

## 30. Genre Feature Context
- Genre detail:
  - owns genre song list
  - owns track more-sheet state
  - pushes artist from track-row actions on the parent navigation stack
- Genre tracks can play directly through `PlayerViewModel`.

## 31. Drawer Context
- Current drawer file:
  - `Screens/ProfileScreen/GuestModeDrawerView.swift`
- Current responsibilities:
  - display current user name
  - show legal/support links
  - perform logout
- RootView hosts the drawer and dimming overlay.

## 32. Navigation Model
- Top-level routing:
  - `ContentView`
- Main app shell:
  - `RootView`
- Tab-root navigation:
  - `NavigationStack`
- Modal patterns used:
  - `sheet`
  - `fullScreenCover`
- Artist navigation strategy:
  - if full artist is known -> use `ArtistDetailView`
  - if only id/name is known -> use `ArtistLoaderView`

## 33. State Management Summary
- App-level route state:
  - `ContentView`
- App-shell state:
  - `RootView`
- Feature state:
  - feature-specific `ViewModel`
- Shared playback state:
  - `PlayerViewModel`
- Persisted session state:
  - keychain + user defaults
- Persisted playback state:
  - user defaults
- Temporary UI state:
  - `@State` in views
- Reactive update channels:
  - `@Published`
  - `Combine`
  - `NotificationCenter`

## 34. Current Known Implementation Notes
- `PlayerViewModel` exists at app level in `resetmusic_ios_localApp`
- `RootView` also creates its own `@StateObject private var playerVM = PlayerViewModel()`
- So the current app has two `PlayerViewModel` creation points.
- The active in-app playback shell is the one inside `RootView`.
- This is worth revisiting later if you want one single global player owner.

## 35. Known Auth Scope
- Email/password auth is fully wired
- Logout is wired
- Forgot password is wired
- Google button is still UI-only placeholder
- Apple sign-in is not yet wired
- OAuth callback URLs for Google are present in `Info.plist`

## 36. Known Player Scope
- Queue persistence is implemented
- Preview cap is implemented
- Interruption recovery is implemented
- Headphone unplug pause is implemented
- AirPlay UI exists
- Search tracks can play directly into shared queue logic

## 37. Important Files to Read First
- `resetmusic_ios_localApp.swift`
- `ContentView.swift`
- `Screens/RootView.swift`
- `Networking/Client/NetworkManager.swift`
- `Networking/AudioSessionManager.swift`
- `Networking/UserDefaultsManager.swift`
- `Networking/KeychainManager.swift`
- `PlayerView/PlayerViewModel.swift`
- `PlayerView/PlayerQueueManager.swift`
- `PlayerView/PlayerAudioEngine.swift`
- `Auth/AuthRepositoryImpl.swift`
- `Auth/Login/LoginViewModel.swift`
- `Auth/Signup/SignUpViewModel.swift`
- `Screens/SearchScreen/SearchViewModel.swift`
- `Screens/SearchScreen/SearchScreen.swift`

## 38. If You Need To Continue This Project Later
- For auth work:
  - start in `ContentView`, `AuthRepositoryImpl`, `AuthEndpoint`, `AuthService`
- For playback work:
  - start in `PlayerViewModel`, `PlayerQueueManager`, `PlayerAudioEngine`
- For interruption/device audio work:
  - start in `AudioSessionManager` and `PlayerViewModel`
- For search work:
  - start in `SearchScreen`, `SearchViewModel`, `SearchEndpoint`
- For cache/data-flow work:
  - start in repositories and their local data sources
