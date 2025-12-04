import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';

void main() {
  group('Cart model', () {
    setUp(() {
      globalCart.clear();
    });

    test('adding items increases totalItems and stores item', () {
      expect(globalCart.totalItems, 0);

  globalCart.add(CartItem(id: 'p1', title: 'Product 1', color: 'Black', size: 'M', price: 10.0));
      expect(globalCart.totalItems, 1);
      expect(globalCart.items.length, 1);

      // adding same product with same variant increments quantity
  globalCart.add(CartItem(id: 'p1', title: 'Product 1', color: 'Black', size: 'M', price: 10.0));
      expect(globalCart.totalItems, 2);
      expect(globalCart.items.length, 1);

      // adding different variant creates a new cart line
  globalCart.add(CartItem(id: 'p1', title: 'Product 1', color: 'Purple', size: 'M', quantity: 2, price: 10.0));
      expect(globalCart.totalItems, 4);
      expect(globalCart.items.length, 2);
    });

    test('updateQuantity and remove work', () {
  globalCart.add(CartItem(id: 'p2', title: 'A', color: 'Grey', size: 'S', quantity: 3, price: 5.0));
      final key = globalCart.items.first.key;
      expect(globalCart.totalItems, 3);

      globalCart.updateQuantity(key, 1);
      expect(globalCart.totalItems, 1);

      globalCart.updateQuantity(key, 0);
      expect(globalCart.totalItems, 0);
      expect(globalCart.items.isEmpty, true);
    });
  });
}
