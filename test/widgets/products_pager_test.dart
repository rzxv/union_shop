import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/utils/products_pagination.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('ProductsPager', () {
    test('filtering/sorting and paging with a small registry', () {
      final registry = <String, Product>{
        'a': const Product(id: 'a', title: 'A', price: 3.0),
        'b': const Product(id: 'b', title: 'B', price: 1.0),
        'c': const Product(id: 'c', title: 'C', price: 2.0),
      };

      final pager = ProductsPager(registry, pageSize: 2);

      // default sort (Featured) preserves insertion order
      final defaultIds = pager.filteredSortedIds();
      expect(defaultIds, containsAll(['a', 'b', 'c']));

      final lowFirst = pager.filteredSortedIds(selectedSort: 'Price: low → high');
      expect(lowFirst, equals(['b', 'c', 'a']));

      final highFirst = pager.filteredSortedIds(selectedSort: 'Price: high → low');
      expect(highFirst, equals(['a', 'c', 'b']));

      // total pages with pageSize 2 over 3 items => 2 pages
      expect(pager.totalPages(), equals(2));

  // page 0 returns first two when using low->high sort
  expect(pager.pageItems(page: 0, selectedSort: 'Price: low → high'), equals(['b', 'c']));
  // page 1 returns last one when using low->high sort
  expect(pager.pageItems(page: 1, selectedSort: 'Price: low → high'), equals(['a']));
      // page beyond range returns empty
      expect(pager.pageItems(page: 2), isEmpty);
    });
  });
}
