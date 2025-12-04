import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/models/product.dart';

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

  static const Map<String, String> _idToType = {
    'autumn_hoodie_1': 'Hoodie',
    'autumn_tshirt_2': 'T-Shirt',
    'autumn_accessory_3': 'Accessory',
    'autumn_hoodie_4': 'Hoodie',
    'autumn_tshirt_5': 'T-Shirt',
    'autumn_accessory_6': 'Accessory',
  };

  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';

  List<String> get _filterOptions => ['All products', 'T-Shirt', 'Hoodie', 'Accessory'];
  List<String> get _sortOptions => ['Featured', 'Price: low → high', 'Price: high → low'];

  List<String> get _filteredSortedProductIds {
    var ids = _autumnIds.where((id) {
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

                      // Wide layout: three columns
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

                      final ids = _filteredSortedProductIds;

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