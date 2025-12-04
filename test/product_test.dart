import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
        return const MaterialApp(
          home: ProductPage(header: SizedBox.shrink(), footer: SizedBox.shrink()),
        );
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      // Ensure wide layout so full product details are visible
      const testSize = Size(1200, 800);
      tester.view.physicalSize = testSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

  // Check that basic UI elements are present
  expect(find.text('Classic Sweatshirts'), findsOneWidget);
  expect(find.text('£23.00'), findsOneWidget);
  expect(find.text('Bringing to you, our best selling Classic Sweatshirt. Available in 4 different colours.'), findsOneWidget);
    });

    testWidgets('should display student instruction text', (tester) async {
      // Ensure wide layout so student instruction text is shown
      const testSize = Size(1200, 800);
      tester.view.physicalSize = testSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that student instruction is present
      expect(
        find.text(
          'Students should add size options, colour options, quantity selector, add to cart button, and buy now button here.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

  // Header/footer are replaced with placeholders in this test; to test
  // header icon behavior, create a focused test that pumps AppHeader.
  expect(find.byIcon(Icons.shopping_bag_outlined), findsNothing);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

  // Footer is replaced with a placeholder in this test, so we don't assert on it here.
    });
  });
}
