import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/cart.dart';

void main() {
  group('Add to cart integration', () {
    setUp(() {
      globalCart.clear();
    });

    testWidgets('tapping ADD TO CART adds an item and header badge updates', (tester) async {
  const testSize = Size(380, 800);
      tester.view.physicalSize = testSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MaterialApp(home: ProductPage()));
      await tester.pumpAndSettle();

      // Ensure cart is empty
      expect(globalCart.totalItems, 0);

      // Tap ADD TO CART (ensure visible first)
      final addFinder = find.text('ADD TO CART');
      expect(addFinder, findsOneWidget);
      await tester.ensureVisible(addFinder);
      await tester.tap(addFinder);
      await tester.pumpAndSettle();

      // Cart model updated
      expect(globalCart.totalItems, 1);

      // Header badge displays 1
      expect(find.text('1'), findsWidgets);
    });
  });
}
