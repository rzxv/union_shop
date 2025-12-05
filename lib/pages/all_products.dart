import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/utils/products_pagination.dart';

class AllProductsPage extends StatefulWidget {
  final Widget header;
  final Widget footer;

  const AllProductsPage({
    super.key,
    this.header = const AppHeader(),
    this.footer = const AppFooter(),
  });

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';
  int _page = 0;
  static const int _pageSize = 6;

  late final ProductsPager _pager = ProductsPager(productRegistry, pageSize: _pageSize);

  List<String> get _sortOptions => ['Featured', 'Price: low → high', 'Price: high → low'];

  // A small heuristic to categorise products by id/title so we can offer
  // filter options similar to the existing collection pages.
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

  List<String> get _allIds => productRegistry.keys.toList();

  List<String> get _filterOptions {
    final types = <String>{};
    for (final id in _allIds) {
      types.add(_typeForId(id));
    }
    final sorted = types.toList()..sort();
    return ['All products', ...sorted];
  }

  List<String> get _filteredSortedIds => _pager.filteredSortedIds(selectedFilter: _selectedFilter, selectedSort: _selectedSort);

  List<String> get _pageItems => _pager.pageItems(page: _page, selectedFilter: _selectedFilter, selectedSort: _selectedSort);

  @override
  Widget build(BuildContext context) {
  final ids = _filteredSortedIds;
  final pageItems = _pageItems;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.header,
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'All Products',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(child: Text('Browse every product in the catalogue', style: TextStyle(color: Colors.grey[600]))),
                    const SizedBox(height: 24),

                    // Filters / Sort (shared UI from products_pagination)
                    ProductListFilters(
                      selectedFilter: _selectedFilter,
                      selectedSort: _selectedSort,
                      filterOptions: _filterOptions,
                      sortOptions: _sortOptions,
                      totalItems: ids.length,
                      onFilterChanged: (f) => setState(() { _selectedFilter = f; _page = 0; }),
                      onSortChanged: (s) => setState(() { _selectedSort = s; _page = 0; }),
                    ),

                    const SizedBox(height: 24),

                    // Products grid (paginated)
                    LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount;
                      if (width > 1100) {
                        crossAxisCount = 3;
                      } else if (width > 700) {
                        crossAxisCount = 2;
                      } else {
                        crossAxisCount = 1;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1,
                        ),
                        itemCount: pageItems.length,
                        itemBuilder: (context, i) {
                          final id = pageItems[i];
                          final prod = productRegistry.containsKey(id) ? productRegistry[id] : null;
                          final title = prod?.title ?? id;
                          final image = (prod != null && prod.images.isNotEmpty) ? prod.images.first : '';
                          final price = prod?.price;

                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/product', arguments: id),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: image.isNotEmpty
                                        ? Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                          )
                                        : Container(color: Colors.grey[300]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        if (prod?.salePrice != null)
                                          Row(
                                            children: [
                                              Text(
                                                '£${price?.toStringAsFixed(2)}',
                                                style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '£${prod!.salePrice!.toStringAsFixed(2)}',
                                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          )
                                        else
                                          Text(price != null ? '£${price.toStringAsFixed(2)}' : '', style: TextStyle(color: Colors.grey[700])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),

                    const SizedBox(height: 18),

                    // Pagination controls (match collection pages)
                      ProductListPagination(
                        page: _page,
                        pageSize: _pageSize,
                        totalItems: ids.length,
                        onPageChanged: (p) => setState(() => _page = p),
                      ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            widget.footer,
          ],
        ),
      ),
    );
  }
}
