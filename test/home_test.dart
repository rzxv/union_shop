import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

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
      await tester.pumpAndSettle();

  // Check that basic UI elements are present
  // AppHeader is replaced with a placeholder in these tests, so we
  // don't assert on its presence here.
  expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
  expect(find.text('PRODUCTS SECTION'), findsOneWidget);
  expect(find.text('OUR RANGE'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
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
      await tester.pumpAndSettle();

      // Check that product cards are displayed
      expect(find.text('Placeholder Product 1'), findsOneWidget);
      expect(find.text('Placeholder Product 2'), findsOneWidget);
      expect(find.text('Placeholder Product 3'), findsOneWidget);
      expect(find.text('Placeholder Product 4'), findsOneWidget);

  // Check prices are displayed (may appear in multiple places so assert at least one)
  expect(find.text('£10.00'), findsWidgets);
  expect(find.text('£15.00'), findsWidgets);
  expect(find.text('£20.00'), findsWidgets);
  expect(find.text('£25.00'), findsWidgets);
    });


    testWidgets('should display footer', (tester) async {
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
      await tester.pumpAndSettle();

      // Footer contains the copyright/credit text
      expect(find.text('© 2025, upsu-store  Powered by Shopify'), findsOneWidget);
    });
  });
}
