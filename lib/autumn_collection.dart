import 'package:flutter/material.dart';
import 'package:union_shop/shared_layout.dart';

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
  // Dummy product data for the Autumn collection
  static final List<Map<String, dynamic>> _allProducts = List.generate(9, (i) {
    final kind = (i % 3 == 0) ? 'Hoodie' : (i % 3 == 1) ? 'T-Shirt' : 'Accessory';
    return {
      'title': 'Autumn $kind ${i + 1}',
      'price': (12 + i * 4).toDouble(),
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      'type': kind,
    };
  });

  String _selectedFilter = 'All products';
  String _selectedSort = 'Featured';

  List<String> get _filterOptions => ['All products', 'T-Shirt', 'Hoodie', 'Accessory'];
  List<String> get _sortOptions => ['Featured', 'Price: low → high', 'Price: high → low'];

  List<Map<String, dynamic>> get _filteredSortedProducts {
    var list = _allProducts.where((p) {
      if (_selectedFilter == 'All products') return true;
      return p['type'] == _selectedFilter;
    }).toList();

    if (_selectedSort == 'Price: low → high') {
      list.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_selectedSort == 'Price: high → low') {
      list.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
    }
    return list;
  }

  void _openProduct(BuildContext context, Map<String, dynamic> product) {
    Navigator.pushNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredSortedProducts;

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
                              child: Text('${products.length} products', style: TextStyle(color: Colors.grey[600])),
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
                              child: Text('${products.length} products', style: TextStyle(color: Colors.grey[600])),
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

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, i) {
                          final p = products[i];
                          return GestureDetector(
                            onTap: () => _openProduct(context, p),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      p['image'] as String,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['title'] as String,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 6),
                                        Text('£${(p['price'] as double).toStringAsFixed(2)}',
                                            style: TextStyle(color: Colors.grey[700])),
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