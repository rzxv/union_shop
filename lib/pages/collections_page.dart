import 'package:flutter/material.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/pages/autumn_collection.dart';

class CollectionsPage extends StatelessWidget {
  final Widget header;
  final Widget footer;

  const CollectionsPage({
    super.key,
    this.header = const AppHeader(),
    this.footer = const AppFooter(),
  });

  // Dummy collections data
  static final List<Map<String, String>> _collections = [
    {
      'title': 'Autumn Favourites',
      'image': 'https://res.cloudinary.com/dl650ouuv/image/upload/v1764876698/autumn_collection_dhyehz.png',
    },
    {
      'title': 'Black Friday',
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    },
    {
      'title': 'Clothing',
      'image': 'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
    },
    {
      'title': 'Essential Range',
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    },
    {
      'title': 'Graduation',
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
    },
    {
      'title': 'Merchandise',
      'image': 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
    },
  ];

  void _openCollection(BuildContext context, Map<String, String> collection) {
    final title = (collection['title'] ?? '').trim();
    if (title == 'Autumn Favourites') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const AutumnCollection()),
      );
    } else {
      // Keep the previous behaviour for other collections
      Navigator.pushNamed(context, '/product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            header,
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
                        'Collections',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
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
                        itemCount: _collections.length,
                        itemBuilder: (context, i) {
                          final item = _collections[i];
                          return GestureDetector(
                            onTap: () => _openCollection(context, item),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    item['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                  ),
                                  Container(color: const Color.fromRGBO(0, 0, 0, 0.45)),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        item['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
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
            footer,
          ],
        ),
      ),
    );
  }
}