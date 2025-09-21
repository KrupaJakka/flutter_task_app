# Flutter Internship Task App

This Flutter application was developed as part of my internship task. It demonstrates my ability to work with Flutter, Firebase, state management, and clean architecture while following a Figma design prototype.

---

## Features

1. **Authentication**
   - Users can log in and log out using Firebase Authentication (email and password).
   - Loading animations are displayed while checking authentication state.

2. **Assessments Module**
   - Displays a list of assessments stored in Cloud Firestore.
   - Supports pagination to load data in small chunks and offline caching for viewing without an internet connection.
   - Pull-to-refresh is implemented.
   - Assessment detail screens use hero animations for smooth transitions.
   - Users can mark assessments as favorites, stored locally.

3. **Appointments Module**
   - Users can view available appointments from Firestore.
   - Bookings are saved under the user's account in Firestore.
   - Calendar view shows available dates.
   - Smooth transitions between screens enhance user experience.

4. **User Interface**
   - Fully responsive UI across small phones, large phones, and tablets.
   - Custom themes for colors, typography, and spacing match the Figma prototype.

5. **Architecture and State Management**
   - Clean architecture separates the app into data, domain, and presentation layers.
   - Riverpod is used for state management to keep widgets simple and move business logic into providers/notifiers.

---

## Project Structure

```
lib/
├─ core/
│  ├─ models/        # Data models
│  ├─ providers/     # Riverpod providers and notifiers
│  └─ utils/         # Utility functions
├─ features/
│  ├─ auth/          # Authentication module
│  ├─ assessments/   # Assessments module
│  └─ appointments/  # Appointments module
└─ main.dart          # App entry point
```

---

## Architecture Decisions

- **Clean Architecture**
  - Separation of layers (data, domain, presentation) improves maintainability and testability.
  - Each feature is modularized to isolate responsibilities.

- **State Management**
  - **Riverpod** is used because of its simplicity, compile-time safety, and easy testing.
  - `StateNotifier` manages complex states (like auth state), while `StreamProvider` listens to Firebase streams.

- **Offline-first Approach**
  - Firestore offline caching ensures that users can still view data without an internet connection.

---

## Challenges Faced

- Handling **async gaps** with `BuildContext` safely across async calls.
- Integrating **Riverpod** with Firebase streams to update UI in real-time.
- Maintaining **responsive layouts** across multiple screen sizes.
- Implementing **pagination and offline caching** in Firestore for large datasets.

---

## How to Run the App

1. Clone the repository:

```bash
git clone <your-repo-url>
cd flutter_task_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Setup Firebase:
   - Create a Firebase project.
   - Enable **Authentication** and **Cloud Firestore**.
   - Download `google-services.json` and place it in `android/app`.
   - For iOS, configure `GoogleService-Info.plist`.

4. Run the app:

```bash
flutter run
```

---

## Dependencies

- Flutter
- Firebase Authentication
- Cloud Firestore (with offline caching and pagination)
- Riverpod (state management)
- Shared Preferences (local favorites)
- Responsive design utilities

---

## Deliverables

- Full working Flutter app
- Clean, modular code with state management
- README explaining setup, architecture, and features
- Screenshots or screen recordings on multiple screen sizes