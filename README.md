
# Union Shop (union_shop)

A small, multi-page Flutter storefront demo app — "Union Shop" — built with Flutter. This repository contains a simple e-commerce-like UI for browsing products, collections, a print/ personalisation flow, cart and an order confirmation flow. The app is implemented as a standard cross-platform Flutter project and is ready to run on web, mobile and desktop targets supported by Flutter.

---

## Table of contents

- About
- Features
- Project structure
- Main screens & routing
- Data and models
- How to run (development)
- Building for production
- Testing
- Notes, limitations and known issues
- Contributing

---

## About

This app is a demonstration of a small online store for a campus/union shop. It contains product listings, featured ranges, a hero carousel with CTAs to collections, account/login pages, a cart flow and a small print-personalisation flow.

The app source is in `lib/` and follows a simple, mostly stateless UI approach with a few stateful widgets where needed (for example a hero carousel). Product data is provided via `productRegistry` (see `lib/models/product.dart`).

---

## Features

- Multi-page navigation using Flutter `routes` and named navigation.
- Hero carousel with autoplay and manual navigation.
- Product cards used across home, collections and product pages.
- Collections pages (e.g. Sale, Autumn) with reusable components.
- Cart and order confirmation flow.
- Simple local data model for Products, Cart, Orders and Auth (see `lib/models`).
- Network images with fallback handling.
- Responsive layout for mobile and wider screens.

---

## Project structure (high-level)

- `lib/main.dart` — App entry point and main UI scaffolding (home screen, hero, footer, product card widgets, route table).
- `lib/models/` — Data models used by the app:
  - `product.dart` — product model and `productRegistry` (source of product data used throughout the app).
  - `cart.dart` — cart model and utilities.
  - `orders.dart` — order representation and helpers.
  - `auth.dart` — minimal auth-related model/skeleton.
- `lib/pages/` — Pages/screens shown by the app (home, about, collections, cart, product page, account, login, signup, order confirmation, the print-shack flow and others).
- `lib/widgets/` — Shared widgets such as `shared_layout.dart` and small UI components reused across pages.
- `test/` — Unit and widget tests that accompany the project (if present).
- Platform directories: `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` for platform-specific builds.

---

## Main screens & routing

`lib/main.dart` declares the app routes using `routes` and `initialRoute: '/'`. Notable routes:

- `/` — Home screen (default)
- `/product` — Product page (expects a product id via `Navigator.pushNamed(context, '/product', arguments: productId)`)
- `/cart` — Cart page
- `/about` — About page
- `/collections` — Collections overview
- `/all-products` — All products page
- `/account`, `/login`, `/signup` — Account and auth pages
- `/order-confirmation` — Order confirmation (expects an `orderId` argument)

Navigation is done using a mix of named routes (`Navigator.pushNamed`) and direct `MaterialPageRoute` navigations for some collection flows.

---

## Data and models

The app uses a small, local, non-networked data layer stored in memory for demonstration purposes. The main contract is:

- Product: contains id, title, price, optional salePrice, list of image URLs, etc.
- Cart: holds items referencing product ids and quantities.
- Orders: simple representation of completed orders.


---

## How to run (development)

Prerequisites:

- Flutter SDK (stable channel recommended). See: https://flutter.dev/docs/get-started/install
- For iOS/macOS builds: Xcode (macOS only).
- For Android builds: Android SDK + emulator or a physical device.

From the project root (where `pubspec.yaml` is located):

```bash
# fetch packages
flutter pub get

# run on connected device or emulator; on macOS you can run web or iOS
# for web (Chrome):
flutter run -d chrome

# run on an attached Android device or emulator
flutter run

# run on macOS (if desktop enabled)
flutter run -d macos
```

Notes:
- The app uses network-hosted images for product/hero assets; ensure your machine has internet access while running.
- The code paths reference `productRegistry` in `lib/models/product.dart` which powers many `ProductCard` widgets — update that registry to change product data shown in the UI.

---

## Building for production

To build a release for Android:

```bash
flutter build apk --release
```

For iOS (from macOS with proper signing set up):

```bash
flutter build ios --release
```

For web:

```bash
flutter build web --release
```

For macOS:

```bash
flutter build macos --release
```

Follow Flutter's platform-specific docs for signing and store deployment.

---

## Testing

Run unit & widget tests with:

```bash
flutter test
```

If you add new tests, keep them fast and focus on unitable parts such as models and small widget behaviors; avoid large integration tests in CI unless necessary.

---

## Notes, limitations and known issues

- Images are loaded from external URLs — missing images will show a fallback icon.
- Auth and payment flows are mock/demo-only and do not integrate with real providers.
- The app aims to be responsive but may need polish on very small or very large screens.

---

## Contributing

Contributions are welcome. A simple workflow:

1. Fork the repository and create a feature branch.
2. Add tests for new behavior where possible.
3. Run `flutter analyze` and `flutter test` locally.
4. Open a pull request describing the change.

Please keep changes small and focused. If adding dependencies, prefer well-maintained packages and add them to `pubspec.yaml`.

---

## Quick references

- Main entry: `lib/main.dart`
- Models: `lib/models/`
- Pages: `lib/pages/`
- Widgets: `lib/widgets/`

