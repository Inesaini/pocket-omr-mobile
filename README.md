# QuiZor — Flutter frontend

Flutter client for **QuiZor**, a platform for creating and evaluating quizzes. Talks to the FastAPI backend located in the sibling `backend/` directory.

## Stack

- Flutter `^3.11.1` (Dart) — Android, iOS, web, macOS, Linux, Windows
- State: `provider` + `ChangeNotifier`
- HTTP: `dio` with an auth-bearer interceptor and auto token refresh
- Token storage: `shared_preferences`

## Prerequisites

- Flutter SDK `^3.11.1`
- The backend running locally on `http://localhost:8000` (see `../backend/README.md`)

## Run

```bash
flutter pub get
flutter run              # default device (iOS sim / desktop / chrome)
flutter run -d chrome    # Flutter web
flutter run -d android   # Android emulator (backend reached via 10.0.2.2)
flutter run -d ios       # iOS simulator
```

The backend host is picked automatically in `lib/core/network/api_constants.dart`:
`10.0.2.2` on Android emulator, `localhost` everywhere else.

## Common commands

```bash
flutter analyze                              # lint
dart format lib test                         # format
flutter test                                 # all tests
flutter test test/widget_test.dart           # single file
flutter test --plain-name "test name"        # single test by name
flutter build apk / ios / web                # release builds
```

## Architecture

Feature-first layout under `lib/`:

```
lib/
├── main.dart                    # entry point + _AuthGate
├── core/
│   ├── network/                 # DioClient, ApiConstants, TokenManager
│   ├── theme/                   # AppColors, AppTheme
│   └── widgets/                 # low-level shared primitives
├── features/
│   ├── auth/                    # login, signup, splash, forgot/reset
│   ├── home/                    # authenticated landing
│   └── profile/                 # profile view + edit
└── shared/widgets/              # cross-feature widgets
```

### Layering (strict)

```
Screen → Provider (ChangeNotifier) → Service → DioClient → backend
```

Screens never call Dio directly. Providers expose state (typically via an
`enum Status`), delegate network work to a service, and notify listeners.

### Auth flow

1. `main.dart` mounts `AuthProvider` in a `MultiProvider`.
2. `_AuthGate` watches `AuthProvider.status`:
   - `authenticated` → `HomePage`
   - anything else → `SplashScreen` (Sign Up / Sign In entry)
3. `AuthProvider._checkAuthStatus()` runs on startup, reads the stored
   access token, calls `GET /auth/me`, and either authenticates or falls
   back to unauthenticated.
4. `DioClient` injects `Authorization: Bearer <access_token>` on every
   request and, on a `401`, calls `POST /auth/refresh`, persists the
   rotated token pair, and retries the original request once.
5. On logout, the provider calls `POST /auth/logout` with the refresh
   token body, which revokes both tokens server-side, then clears local
   storage.

## Backend contract (summary)

Base URL: `http://<host>:8000/api/v1`

| Method | Path             | Auth   | Purpose                                  |
|--------|------------------|--------|------------------------------------------|
| POST   | `/auth/register` | no     | create account, returns token pair       |
| POST   | `/auth/login`    | no     | returns token pair                       |
| GET    | `/auth/me`       | bearer | current user profile                     |
| POST   | `/auth/refresh`  | no     | rotate access + refresh tokens           |
| POST   | `/auth/logout`   | bearer | revoke access + refresh token            |

Field names are snake_case (`first_name`, `last_name`, `access_token`,
`refresh_token`, `is_active`, …). Errors come as `{"detail": "..."}`.

Password policy (enforced on both client and server): ≥8 chars, at least
one uppercase, one lowercase, one digit.

## Gotchas

- **Android emulator** must reach the host via `10.0.2.2`, not
  `localhost`. This is handled automatically by `ApiConstants`.
- **Physical device on Wi-Fi** needs your machine's LAN IP instead; edit
  `ApiConstants._host` if you run on a real phone.
- **Flutter web** (`flutter run -d chrome`) requires CORS on the backend;
  it is enabled permissively in `backend/app/main.py` for development.
- `lib/app.dart` is unused dead code. The real entry point is `main.dart`.
- The edit-profile page is UI-only; there is no `PATCH /auth/me` endpoint
  yet, so saving shows a "not yet supported" snackbar.
