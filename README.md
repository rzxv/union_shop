# Union Shop

Union Shop is a small multi-page Flutter storefront demo app. It demonstrates product browsing, collection pages, a hero carousel, a simple print-personalisation flow, a cart, and an order confirmation flow. The app is implemented as a standard cross-platform Flutter project and runs on web, mobile and desktop targets supported by Flutter.

---

## Table of contents

- About
- Quick start
- Development & testing
- Building for release
- Project structure
- Contributing
- Notes & limitations

---

## About

This repository contains a demo e-commerce UI meant for learning and prototyping. It uses a local in-memory data layer (see `lib/models/product.dart`) and minimal auth/cart logic for demonstration purposes. It is not intended for production use.

## Quick start

Prerequisites

- Flutter SDK (stable channel recommended). See: https://flutter.dev/docs/get-started/install
- Optional: Xcode (macOS) for iOS/macOS builds; Android SDK for Android builds.

From the project root (where `pubspec.yaml` is located):

```bash
# fetch packages
flutter pub get

# run in Chrome (web)
flutter run -d chrome

# run on default connected device or emulator
flutter run

# run desktop (macOS) if enabled
flutter run -d macos
```

Notes

- Product images are hosted externally — make sure you have internet access when running the app.
- To change sample products, edit the `productRegistry` in `lib/models/product.dart`.

---

## Development & testing

Run the analyzer and tests locally:

```bash
flutter analyze
flutter test
```

Testing guidance

- Keep unit and widget tests fast. Focus on model logic and small widgets.
- Avoid slow integration tests in routine local runs; reserve them for CI if needed.

---

## Building for release

Android:

```bash
flutter build apk --release
```

iOS (macOS with proper signing):

```bash
flutter build ios --release
```

Web:

```bash
flutter build web --release
```

macOS:

```bash
flutter build macos --release
```

Follow Flutter's platform docs for distribution and signing details.

---

## Project structure (high level)

- `lib/main.dart` — App entry point and route setup.
- `lib/models/` — Data models (products, cart, orders, auth skeleton).
- `lib/pages/` — Screens (home, product, collections, cart, account, login/signup, order confirmation, print flow).
- `lib/widgets/` — Shared UI components and layout scaffolding.
- `test/` — Unit and widget tests.

Platform-specific folders: `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`.

---

## Contributing

Contributions welcome. Suggested workflow:

1. Fork and create a feature branch.
2. Add tests for new behavior when possible.
3. Run `flutter analyze` and `flutter test`.
4. Open a pull request describing your change.

Prefer small, focused changes and well-maintained dependencies.

---

## Notes & limitations

- Images are loaded from external URLs — missing images will show a fallback.
- Auth and payment functionality is mock/demo-only and should not be used in production.
- The UI aims to be responsive but may need adjustments for extreme screen sizes.

---

## Contact

If you have questions or suggestions, open an issue or a PR in this repository.
