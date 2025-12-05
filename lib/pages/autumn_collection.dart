import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/utils/products_pagination.dart';

class AutumnCollection extends StatefulWidget {
  final Widget header;
  final Widget footer;

  const AutumnCollection({
    super.key,
    this.header = const AppHeader(),
    this.footer = const AppFooter(),
  });

  @override
  State<AutumnCollection> createState() => _AutumnCollectionState();
}

class _AutumnCollectionState extends State<AutumnCollection> {
  // Explicit Autumn collection products (6 items). Each entry includes an
  // `id` that must match the keys in `productRegistry` so the product page
  // can resolve full product data.
  static const List<String> _autumnIds = [
    'autumn_hoodie_1',
    'autumn_tshirt_2',
    'autumn_accessory_3',
    'autumn_hoodie_4',
    'autumn_tshirt_5',
    'autumn_accessory_6',
  ];


  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';
  int _page = 0;
  static const int _pageSize = 6;
  late final ProductsPager _pager = ProductsPager(productRegistry, pageSize: _pageSize, sourceIds: _autumnIds);

  List<String> get _filterOptions => ['All products', 'T-Shirt', 'Hoodie', 'Accessory'];
  List<String> get _sortOptions => ['Featured', 'Price: low → high', 'Price: high → low'];

  List<String> get _filteredSortedProductIds => _pager.filteredSortedIds(selectedFilter: _selectedFilter, selectedSort: _selectedSort);

  List<String> get _pageItems => _pager.pageItems(page: _page, selectedFilter: _selectedFilter, selectedSort: _selectedSort);

  @override
  Widget build(BuildContext context) {
    final ids = _filteredSortedProductIds;
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
                        'Autumn Favourites',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Shop all of this collection\'s items in one place',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Filters / Sort - responsive: stack on narrow widths
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

                    // Products grid
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
                                        Text(
                                          title,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          price != null ? '£${price.toStringAsFixed(2)}' : '',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
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