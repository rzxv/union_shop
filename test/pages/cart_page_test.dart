import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:union_shop/pages/order_confirmation.dart';

void main() {
  group('Cart page', () {
    setUp(() {
      globalCart.clear();
    });

    testWidgets('shows items, can change qty and remove, checkout clears cart', (tester) async {
      await mockNetworkImagesFor(() async {
  // populate cart
  globalCart.add(CartItem(id: 'p1', title: 'Product 1', color: 'Black', size: 'S', price: 12.5));
  globalCart.add(CartItem(id: 'p2', title: 'Product 2', color: 'Grey', size: 'M', quantity: 2, price: 7.0));

        // Instead of navigating via the shared header (which is complex in
        // tests), just pump the CartPage directly and provide a minimal
        // header to avoid AppHeader layout.
        await tester.pumpWidget(MaterialApp(
          routes: {
            '/order-confirmation': (ctx) {
              final id = ModalRoute.of(ctx)!.settings.arguments as String;
              return OrderConfirmationPage(orderId: id);
            }
          },
          home: CartPage(header: const SizedBox.shrink(), footer: const SizedBox.shrink()),
        ));
        await tester.pumpAndSettle();

        // Cart page shows product titles
        expect(find.text('Product 1'), findsOneWidget);
        expect(find.text('Product 2'), findsOneWidget);

        // Increase qty for product 1
        final p1Key = globalCart.items.first.key; // p1
        final inc = find.byKey(ValueKey('inc-$p1Key'));
        expect(inc, findsOneWidget);
  await tester.ensureVisible(inc);
  await tester.tap(inc);
        await tester.pumpAndSettle();
        expect(globalCart.totalItems, 4); // was 3, p1 incremented to 2 -> total 4

        // Remove product 2
        final p2Key = globalCart.items.firstWhere((it) => it.id == 'p2').key;
        final remove = find.byKey(ValueKey('remove-$p2Key'));
        expect(remove, findsOneWidget);
  await tester.ensureVisible(remove);
  await tester.tap(remove);
        await tester.pumpAndSettle();
        expect(globalCart.items.any((it) => it.id == 'p2'), isFalse);

        // Checkout clears cart and shows dialog
        final checkout = find.byKey(const ValueKey('checkout'));
        expect(checkout, findsOneWidget);
  await tester.ensureVisible(checkout);
  await tester.tap(checkout);
  await tester.pumpAndSettle();

  // Navigated to order confirmation
  await tester.pumpAndSettle();
  expect(find.text('Order Confirmation'), findsOneWidget);
  // Cart cleared
  expect(globalCart.totalItems, 0);
      });
    });
  });
}
