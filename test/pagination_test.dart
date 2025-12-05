import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/utils/products_pagination.dart';

void main() {
  final pager = ProductsPager(productRegistry, pageSize: 6);

  test('total pages equals ceil(total / pageSize)', () {
    final total = productRegistry.length;
    final expected = (total / 6).ceil();
    expect(pager.totalPages(), expected);
  });

  test('pageItems returns up to pageSize items and last page may be smaller', () {
    final total = productRegistry.length;
    final totalPages = pager.totalPages();

    for (var p = 0; p < totalPages; p++) {
      final items = pager.pageItems(page: p);
      if (p < totalPages - 1) {
        expect(items.length, 6);
      } else {
        expect(items.length, total - (p * 6));
      }
    }
  });

  test('filter reduces the result set and affects totalPages', () {
    // Pick the 'Hoodie' filter which exists in the registry
    final hoodies = pager.filteredSortedIds(selectedFilter: 'Hoodie');
    final pagesWithHoodie = pager.totalPages(selectedFilter: 'Hoodie');

    expect(hoodies.every((id) => id.toLowerCase().contains('hoodie')), isTrue);
    expect(pagesWithHoodie, (hoodies.length / 6).ceil());
  });

  test('sorting low->high orders items by ascending price', () {
    final ids = pager.filteredSortedIds(selectedSort: 'Price: low → high');
    if (ids.length >= 2) {
      final p0 = productRegistry[ids[0]]!.price;
      final p1 = productRegistry[ids[1]]!.price;
      expect(p0 <= p1, isTrue);
    }
  });
}
