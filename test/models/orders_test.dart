import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/orders.dart';

void main() {
  group('Orders and Order', () {
    test('Order computes totalItems and totalPrice', () {
      final order = Order(
        id: 'o1',
        placedAt: DateTime.now(),
        items: [
          OrderItem(id: 'a', title: 'A', color: '', size: '', quantity: 2, price: 3.0),
          OrderItem(id: 'b', title: 'B', color: '', size: '', quantity: 1, price: 4.5),
        ],
      );

      expect(order.totalItems, equals(3));
      expect(order.totalPrice, closeTo(10.5, 0.0001));
    });

    test('Orders add and clear', () {
      final orders = Orders();
      expect(orders.orders, isEmpty);

      final order = Order(id: 'o2', placedAt: DateTime.now(), items: [OrderItem(id: 'x', title: 'X', color: '', size: '', quantity: 1, price: 1.0)]);
      orders.add(order);
      expect(orders.orders.length, equals(1));

      orders.clear();
      expect(orders.orders, isEmpty);
    });
  });
}
