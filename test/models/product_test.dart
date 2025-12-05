import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product model', () {
    test('defaults are set when optional fields omitted', () {
      const p = Product(id: 'id1', title: 'Title', price: 1.23);
      expect(p.images, isA<List<String>>());
      expect(p.images, isEmpty);
      expect(p.colors, equals(['Black']));
      expect(p.sizes, equals(['S', 'M', 'L']));
      expect(p.salePrice, isNull);
      expect(p.description, equals(''));
    });

    test('productRegistry contains expected entries', () {
      expect(productRegistry.containsKey('essential_tshirt'), isTrue);
      final tshirt = productRegistry['essential_tshirt']!;
      expect(tshirt.title, contains('Essential'));
      expect(tshirt.price, closeTo(6.99, 0.001));
    });
  });
}
