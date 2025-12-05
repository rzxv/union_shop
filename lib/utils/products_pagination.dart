import 'package:union_shop/models/product.dart';
import 'package:flutter/material.dart';

typedef FilterChanged = void Function(String filter);
typedef SortChanged = void Function(String sort);
typedef PageChanged = void Function(int page);

/// Reusable filter + sort controls. This widget renders the responsive
/// dropdowns used across collection pages. It doesn't manage data — it merely
/// displays the UI and forwards user actions via callbacks.
class ProductListFilters extends StatelessWidget {
  final String selectedFilter;
  final String selectedSort;
  final List<String> filterOptions;
  final List<String> sortOptions;
  final FilterChanged onFilterChanged;
  final SortChanged onSortChanged;
  final int totalItems;

  const ProductListFilters({
    super.key,
    required this.selectedFilter,
    required this.selectedSort,
    required this.filterOptions,
    required this.sortOptions,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 440;
      if (isNarrow) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('FILTER BY', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFilter,
                    items: filterOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (s) => onFilterChanged(s ?? 'All products'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('SORT BY', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSort,
                    items: sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (s) => onSortChanged(s ?? 'Featured'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: Text('$totalItems products', style: TextStyle(color: Colors.grey[600]))),
          ],
        );
      }

      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('FILTER BY', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFilter,
                    items: filterOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (s) => onFilterChanged(s ?? 'All products'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('SORT BY', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSort,
                    items: sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (s) => onSortChanged(s ?? 'Featured'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('$totalItems products', style: TextStyle(color: Colors.grey[600])))),
        ],
      );
    });
  }
}

/// Pagination controls: rectangular unfilled Prev/Next buttons and range
/// summary. Keeps styling consistent with collection pages.
class ProductListPagination extends StatelessWidget {
  final int page;
  final int pageSize;
  final int totalItems;
  final PageChanged onPageChanged;

  const ProductListPagination({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = page * pageSize + (totalItems == 0 ? 0 : 1);
    final remaining = totalItems - page * pageSize;
    final shown = remaining <= 0 ? 0 : (remaining < pageSize ? remaining : pageSize);
    final totalPages = (totalItems / pageSize).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Showing $start - ${start + (shown == 0 ? 0 : shown - 1)} of $totalItems', style: TextStyle(color: Colors.grey[700])),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: page > 0 ? () => onPageChanged(page - 1) : null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF4d2963)),
            foregroundColor: const Color(0xFF4d2963),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          child: const Text('Previous'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: page < (totalPages - 1) ? () => onPageChanged(page + 1) : null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF4d2963)),
            foregroundColor: const Color(0xFF4d2963),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}

/// Helper responsible for filtering, sorting and paging product ids from the
/// shared `productRegistry`. This is intentionally small and pure so it can be
/// easily unit-tested.
class ProductsPager {
  final Map<String, Product> registry;
  final int pageSize;
  final List<String> _sourceIds;

  /// Create a pager over [registry]. Optionally provide [sourceIds] to limit
  /// the pager to a specific subset (useful for collections).
  ProductsPager(this.registry, {this.pageSize = 6, List<String>? sourceIds}) : _sourceIds = sourceIds ?? registry.keys.toList();

  String _typeForId(String id) {
    final lower = id.toLowerCase();
    if (lower.contains('hoodie')) return 'Hoodie';
    if (lower.contains('tshirt') || lower.contains('t-shirt') || lower.contains('tee')) return 'T-Shirt';
    if (lower.contains('accessory') || lower.contains('beanie') || lower.contains('scarf')) return 'Accessory';
    if (lower.contains('cd')) return 'CD';
    if (lower.contains('vinyl')) return 'Vinyl';
    if (lower.contains('mug') || lower.contains('cap')) return 'Merchandise';
    return 'Other';
  }

  List<String> filteredSortedIds({String selectedFilter = 'All products', String selectedSort = 'Featured'}) {
    final ids = _sourceIds.where((id) {
      if (selectedFilter == 'All products') return true;
      return _typeForId(id) == selectedFilter;
    }).toList();

    if (selectedSort == 'Price: low → high') {
      ids.sort((a, b) {
        final pa = registry[a]?.price ?? double.infinity;
        final pb = registry[b]?.price ?? double.infinity;
        return pa.compareTo(pb);
      });
    } else if (selectedSort == 'Price: high → low') {
      ids.sort((a, b) {
        final pa = registry[a]?.price ?? double.negativeInfinity;
        final pb = registry[b]?.price ?? double.negativeInfinity;
        return pb.compareTo(pa);
      });
    }

    return ids;
  }

  int totalPages({String selectedFilter = 'All products', String selectedSort = 'Featured'}) {
    final total = filteredSortedIds(selectedFilter: selectedFilter, selectedSort: selectedSort).length;
    return (total / pageSize).ceil();
  }

  List<String> pageItems({required int page, String selectedFilter = 'All products', String selectedSort = 'Featured'}) {
    final ids = filteredSortedIds(selectedFilter: selectedFilter, selectedSort: selectedSort);
    final start = page * pageSize;
    if (start >= ids.length) return <String>[];
    return ids.skip(start).take(pageSize).toList();
  }
}
