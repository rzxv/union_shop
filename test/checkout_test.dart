import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/cart_page.dart';
import 'package:union_shop/orders.dart';
import 'package:union_shop/order_confirmation.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('Checkout flow', () {
    setUp(() {
      globalCart.clear();
      globalOrders.clear();
    });

    testWidgets('placing an order clears cart and records an order', (tester) async {
      await mockNetworkImagesFor(() async {
        // populate cart
  globalCart.add(CartItem(id: 'p1', title: 'Product 1', color: 'Black', size: 'S', price: 11.0));
  globalCart.add(CartItem(id: 'p2', title: 'Product 2', color: 'Grey', size: 'M', quantity: 2, price: 6.5));

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

        // Sanity
        expect(globalCart.totalItems, 3);
        expect(globalOrders.orders, isEmpty);

        // Tap checkout
  final checkout = find.byKey(const ValueKey('checkout'));
  expect(checkout, findsOneWidget);
  await tester.ensureVisible(checkout);
  await tester.tap(checkout);
  await tester.pumpAndSettle();

  // Should navigate to Order Confirmation page
  await tester.pumpAndSettle();
  expect(find.text('Order Confirmation'), findsOneWidget);

  // Cart cleared and order recorded
  expect(globalCart.totalItems, 0);
  expect(globalOrders.orders.length, 1);
  final recorded = globalOrders.orders.first;
  expect(recorded.totalItems, 3);
      });
    });
  });
}
