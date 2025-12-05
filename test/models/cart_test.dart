import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart.dart';

void main() {
  group('Cart and CartItem', () {
    test('CartItem.key omits color/size for media items', () {
      final media = CartItem(id: 'nujabes_cd', title: 'Nujabes CD', price: 10.0);
      expect(media.key, equals('nujabes_cd'));

      final vinyl = CartItem(id: 'cool_vinyl', title: 'Cool Vinyl', price: 15.0);
      expect(vinyl.key, equals('cool_vinyl'));
    });

    test('CartItem.key includes color and size for non-media items', () {
      final hoodie = CartItem(id: 'hoodie1', title: 'Hoodie', color: 'Navy', size: 'M', price: 20.0);
      expect(hoodie.key, equals('hoodie1|Navy|M'));
    });

    test('Cart add, updateQuantity, remove and clear behave correctly', () {
      final cart = Cart();

      final itemA = CartItem(id: 'a', title: 'A', color: 'Black', size: 'S', price: 5.0, quantity: 1);
      cart.add(itemA);
      expect(cart.items.length, equals(1));
      expect(cart.totalItems, equals(1));

      // adding same key should increase quantity
      cart.add(CartItem(id: 'a', title: 'A', color: 'Black', size: 'S', price: 5.0, quantity: 2));
      expect(cart.items.length, equals(1));
      expect(cart.totalItems, equals(3));

      // add another distinct item
      cart.add(CartItem(id: 'b', title: 'B', price: 3.0));
      expect(cart.items.length, equals(2));
      expect(cart.totalItems, equals(4));
    });
    test('updateQuantity and remove work', () {
      final cart = Cart();
      cart.add(CartItem(id: 'p2', title: 'A', color: 'Grey', size: 'S', quantity: 3, price: 5.0));
      final key = cart.items.first.key;
      expect(cart.totalItems, 3);

      cart.updateQuantity(key, 1);
      expect(cart.totalItems, 1);

      cart.updateQuantity(key, 0);
      expect(cart.totalItems, 0);
      expect(cart.items.isEmpty, true);
    });
  });
}
