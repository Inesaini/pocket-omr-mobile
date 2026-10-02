# Pocket OMR — Mobile app

Flutter app for **Pocket OMR**, an end-to-end Optical Mark Recognition system that grades
multiple-choice exam sheets photographed with an ordinary smartphone.

The mobile app is the teacher's tool in the classroom: pick an exam, photograph the filled
answer sheets, and see each student's grade a few seconds later. Recognition runs on the
backend, which reads both the answer bubbles and the handwritten student name on each sheet.

<!-- TODO(Ines): add 3–4 screenshots (home, camera, results, history) to docs/screenshots/
     and uncomment:
| Home | Scan | Results | History |
|---|---|---|---|
| ![Home](docs/screenshots/home.png) | ![Scan](docs/screenshots/camera.png) | ![Results](docs/screenshots/results.png) | ![History](docs/screenshots/history.png) |
-->

## Features

- **Scan answer sheets** with the in-app camera, or pick existing photos or a `.zip` of a
  whole class from the device.
- **Automatic grading** — sheets are uploaded to the backend and come back with the
  recognised student, score and confidence.
- **Retry failed sheets** — if a photo can't be read, a dialog lists the failed sheets and
  re-uploads only those.
- **Review flags** — questions the model was unsure about are highlighted per student
  ("Review Q2, Q5") so the teacher can check them by hand.
- **Exam list and search** — exams still to correct, recent activity, and a searchable
  history with average score and confidence per exam.
- **Manage results** — open an exam's results, keep scanning, or delete a wrongly graded
  paper.
- **Accounts** — sign up, sign in, password reset by email code, profile view and edit,
  with automatic token refresh.

## Stack

- Flutter `^3.11.1` (Dart) — Android, iOS, web, macOS, Linux, Windows
- State: `provider` + `ChangeNotifier`
- HTTP: `dio` with an auth-bearer interceptor and auto token refresh
- Token storage: `shared_preferences`
- Capture: `camera`, `image_picker`, `file_picker`, `permission_handler`

## Prerequisites

- Flutter SDK `^3.11.1`
- The Pocket OMR backend running on `http://localhost:8000`
  ([pocket-omr/backend](https://github.com/pocket-omr/backend), branch `new-backend`)

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

To run on a physical Android phone over Wi-Fi, pass your computer's LAN IP:

```bash
./run_phone.sh 192.168.1.6
```

The script builds the app with that backend address, re-signs the APK (some OEM ROMs reject
the default debug signature), installs it and launches it.

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
│   ├── auth/                    # login, signup, splash, forgot/reset password
│   ├── pocket_omr/              # the OMR workflow
│   │   ├── screens/             # home, exam list, camera, results, history
│   │   ├── services/            # ExamService, upload flow with retry
│   │   ├── models/              # Exam, student results
│   │   ├── shell/               # bottom-navigation shell
│   │   └── widgets/             # results body, confidence bar, ring progress, dialogs
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

### Scan and grade flow

1. The teacher opens an exam from the list of exams to correct.
2. Sheets are captured with the camera screen, or selected as images or a `.zip`.
3. `uploadSheetsWithProgress` sends them to `POST /exams/{id}/upload-images` behind a
   blocking progress dialog.
4. The backend returns the updated exam with every student's result; the results screen
   shows score, confidence and any questions flagged for review.
5. Sheets the backend couldn't segment are listed in a dialog with a **Retry** action that
   re-uploads only those.

### Auth flow

1. `main.dart` mounts `AuthProvider` in a `MultiProvider`.
2. `_AuthGate` watches `AuthProvider.status`:
   - `authenticated` → the main shell
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

| Method | Path                                      | Auth   | Purpose                                   |
|--------|-------------------------------------------|--------|-------------------------------------------|
| POST   | `/auth/register`                          | no     | create account, returns token pair        |
| POST   | `/auth/login`                             | no     | returns token pair                        |
| GET    | `/auth/me`                                | bearer | current user profile                      |
| PUT    | `/auth/me`                                | bearer | update profile                            |
| POST   | `/auth/refresh`                           | no     | rotate access + refresh tokens            |
| POST   | `/auth/logout`                            | bearer | revoke access + refresh token             |
| GET    | `/exams/recent`                           | bearer | recently updated exams                    |
| GET    | `/exams/to-correct`                       | bearer | exams still being corrected (`?search=`)  |
| GET    | `/exams/history`                          | bearer | all exams with average score/confidence   |
| GET    | `/exams/{id}/mobile`                      | bearer | exam with per-student results             |
| POST   | `/exams/{id}/upload-images`               | bearer | upload sheets (images or `.zip`) to grade |
| DELETE | `/exams/{id}/submissions/{submission_id}` | bearer | remove one graded paper                   |

Field names are snake_case (`first_name`, `last_name`, `access_token`,
`refresh_token`, `is_active`, …). Errors come as `{"detail": "..."}`.

Password policy (enforced on both client and server): ≥8 chars, at least
one uppercase, one lowercase, one digit.

## Gotchas

- **Android emulator** must reach the host via `10.0.2.2`, not
  `localhost`. This is handled automatically by `ApiConstants`.
- **Physical device on Wi-Fi** needs your machine's LAN IP instead; use
  `run_phone.sh` or edit `ApiConstants._host`.
- **Flutter web** (`flutter run -d chrome`) requires CORS on the backend;
  it is enabled permissively in the backend's `app/main.py` for development.
- `lib/app.dart` is unused dead code. The real entry point is `main.dart`.

## About the project

Pocket OMR was built as a pluridisciplinary project at the École Supérieure en Informatique
de Sidi Bel Abbès (2025/2026) by a team of six, supervised by Pr. Oussama Serhane. The
system has three parts:

- **Backend** — FastAPI service with the grading pipeline (OpenCV segmentation, YOLOv8 and
  CNN models for bubbles, a CNN for handwritten names)
- **Web app** — React + Vite, for teachers to create exams, print sheets and export grades
- **Mobile app** (this repository) — on-site capture and result review

### My contribution

I built this entire mobile app: authentication, the home, exam list, camera, results,
history and profile screens, the upload and retry flow, and the networking layer that
connects it to the backend.

Beyond this repository, I built the whole
[backend](https://github.com/Inesaini/pocket-omr-backend), including the student list
feature, improved the web frontend, and contributed to the handwritten name recognition
model and the sheet segmentation pipeline.
