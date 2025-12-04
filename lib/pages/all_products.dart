import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';

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

  List<String> get _filteredSortedIds {
    var ids = _allIds.where((id) {
      if (_selectedFilter == 'All products') return true;
      return _typeForId(id) == _selectedFilter;
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

  @override
  Widget build(BuildContext context) {
    final ids = _filteredSortedIds;

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

                    // Filters / Sort
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
                            Align(alignment: Alignment.centerRight, child: Text('${ids.length} products', style: TextStyle(color: Colors.grey[600]))),
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
                          Expanded(child: Align(alignment: Alignment.centerRight, child: Text('${ids.length} products', style: TextStyle(color: Colors.grey[600])))),
                        ],
                      );
                    }),

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
                        itemCount: ids.length,
                        itemBuilder: (context, i) {
                          final id = ids[i];
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
