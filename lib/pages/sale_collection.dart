import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/pages/product_page.dart';

class SaleCollection extends StatefulWidget {
  final Widget header;
  final Widget footer;

  const SaleCollection({
    super.key,
    this.header = const AppHeader(),
    this.footer = const AppFooter(),
  });

  @override
  State<SaleCollection> createState() => _SaleCollectionState();
}

class _SaleCollectionState extends State<SaleCollection> {
  // Use product ids that are stored in productRegistry so sale items are
  // addressable across the app.
  static const List<String> _saleIds = [
    'nujabes_cd',
    'nujabes_vinyl',
    'motfd_cd',
    'motfd_vinyl',
    'radiohead_cd',
    'radiohead_vinyl',
  ];

  static const Map<String, String> _idToType = {
    'nujabes_cd': 'CD',
    'nujabes_vinyl': 'Vinyl',
    'motfd_cd': 'CD',
    'motfd_vinyl': 'Vinyl',
    'radiohead_cd': 'CD',
    'radiohead_vinyl': 'Vinyl',
  };

  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';

  List<String> get _filterOptions => ['All products', 'CD', 'Vinyl'];
  List<String> get _sortOptions => ['Featured', 'Price: low → high', 'Price: high → low'];

  List<String> get _filteredSortedProductIds {
    var ids = _saleIds.where((id) {
      if (_selectedFilter == 'All products') return true;
      return _idToType[id] == _selectedFilter;
    }).toList();

    if (_selectedSort == 'Price: low → high') {
      ids.sort((a, b) {
        final pa = productRegistry[a]?.price ?? double.infinity;
        final pb = productRegistry[b]?.price ?? double.infinity;
        return pa.compareTo(pb);
      });
    } else if (_selectedSort == 'Price: high → low') {
      ids.sort((a, b) {
        final pa = productRegistry[a]?.price ?? double.negativeInfinity;
        final pb = productRegistry[b]?.price ?? double.negativeInfinity;
        return pb.compareTo(pa);
      });
    }

    return ids;
  }

  double _discountedPrice(double p) => (p * 0.65); // 35% off for demo

  @override
  Widget build(BuildContext context) {
    final ids = _filteredSortedProductIds;

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
                        'Music Sale collection',
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
                        'Limited time — extra 35% off selected items. While stocks last!',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Reuse the same filtering / sorting layout as Autumn
                    LayoutBuilder(builder: (context, constraints) {
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
                                    value: _selectedFilter,
                                    items: _filterOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                                    onChanged: (s) => setState(() => _selectedFilter = s ?? 'All products'),
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
                                    value: _selectedSort,
                                    items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                    onChanged: (s) => setState(() => _selectedSort = s ?? 'Featured'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text('${ids.length} products', style: TextStyle(color: Colors.grey[600])),
                            ),
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
                                    value: _selectedFilter,
                                    items: _filterOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                                    onChanged: (s) => setState(() => _selectedFilter = s ?? 'All products'),
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
                                    value: _selectedSort,
                                    items: _sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                    onChanged: (s) => setState(() => _selectedSort = s ?? 'Featured'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('${ids.length} products', style: TextStyle(color: Colors.grey[600])),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),

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
                        itemCount: _filteredSortedProductIds.length,
                        itemBuilder: (context, i) {
                          final id = _filteredSortedProductIds[i];
                          final prod = productRegistry.containsKey(id) ? productRegistry[id] : null;
                          final original = prod?.price ?? 0.0;
                          final discounted = _discountedPrice(original);

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => ProductPage(product: prod)),
                            ),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: (prod != null && prod.images.isNotEmpty)
                                        ? Image.network(
                                            prod.images.first,
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
                                          prod?.title ?? id,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text('£${original.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                                            const SizedBox(width: 8),
                                            Text('£${discounted.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                                          ],
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
