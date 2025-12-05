import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Home Page Tests', () {
    // Use a desktop-sized window for these tests so header/footer layout
    // render in their wide layout and avoid RenderFlex overflow in the test
    // environment.
    const testSize = Size(1200, 800);

    setUpAll(() {
      // nothing to do globally here
    });

    testWidgets('should display home page with basic elements', (tester) async {
      await mockNetworkImagesFor(() async {
      tester.view.physicalSize = testSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(header: SizedBox.shrink()),
        ),
      );
      // Don't use pumpAndSettle: HeroCarousel runs a periodic timer which
      // prevents the test harness from becoming idle. Use a short pump
      // to allow initial layout to settle.
      await tester.pump(const Duration(milliseconds: 100));

  // Check that basic UI elements are present
  // AppHeader is replaced with a placeholder in these tests, so we
  // don't assert on its presence here.
  expect(find.text('ESSENTIAL RANGE'), findsOneWidget);
  expect(find.text('PRODUCTS SECTION'), findsOneWidget);
  // The site no longer has an "OUR RANGE" section; assert the
  // Signature range heading that is present in the current UI.
  expect(find.text('SIGNATURE RANGE'), findsOneWidget);
      });
    });

    testWidgets('should display product cards', (tester) async {
      await mockNetworkImagesFor(() async {
        tester.view.physicalSize = testSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: const HomeScreen(header: SizedBox.shrink()),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Check that product cards are displayed using current product
        // titles from `lib/models/product.dart` which are rendered on
        // the HomeScreen.
        expect(find.text('Nujabes — Metaphorical Music (Vinyl)'), findsOneWidget);
        expect(find.text('Radiohead — OK Computer (Vinyl)'), findsOneWidget);
        expect(find.text('Russet Zip Hoodie'), findsOneWidget);
        expect(find.text('Wool Knit Beanie'), findsOneWidget);

        // Check prices are displayed (may appear in multiple places so assert at least one)
        expect(find.text('£34.99'), findsWidgets);
        expect(find.text('£22.74'), findsWidgets);
        expect(find.text('£18.99'), findsWidgets);
        expect(find.text('£6.99'), findsWidgets);
      });
    });


    testWidgets('should display footer', (tester) async {
      await mockNetworkImagesFor(() async {
        tester.view.physicalSize = testSize;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: const HomeScreen(header: SizedBox.shrink()),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Footer contains the copyright/credit text
        expect(find.text('© 2025, upsu-store  Powered by Shopify'), findsOneWidget);
      });
    });
  });
}
