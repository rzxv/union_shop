import 'package:flutter/material.dart';
import 'package:union_shop/pages/about.dart';
import 'package:union_shop/pages/product_page.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/widgets/shared_layout.dart';
import 'package:union_shop/pages/collections_page.dart';
import 'package:union_shop/pages/sale_collection.dart';
import 'package:union_shop/pages/cart_page.dart';
import 'package:union_shop/pages/order_confirmation.dart';
import 'dart:async';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      routes: {
  '/cart': (context) => CartPage(),
        '/product': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String?;
          final prod = id != null && productRegistry.containsKey(id) ? productRegistry[id] : null;
          return ProductPage(product: prod);
        },
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsPage(),
        '/order-confirmation': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return OrderConfirmationPage(orderId: id);
        },
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Widget header;

  const HomeScreen({super.key, this.header = const AppHeader()});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            header,

            // Hero Section (unchanged)
            HeroCarousel(),

            // Featured essentials Section
            Container(
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  // slightly wider so product cards appear larger on desktop
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'ESSENTIAL RANGE',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        LayoutBuilder(builder: (context, constraints) {
                          final wide = constraints.maxWidth > 900;
                          final columns = wide ? 2 : 1;
                          final childAspect = wide ? 1.45 : 1.6; // slightly taller on desktop
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: columns,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 48,
                            childAspectRatio: childAspect,
                            children: [
                              // Use ProductCard backed by productRegistry so updates live in lib/product.dart
                              Center(child: ProductCard(productId: 'limited_essential_zip_hoodie')),
                              Center(child: ProductCard(productId: 'essential_tshirt')),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Signature range 
            Container(
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'SIGNATURE RANGE',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        LayoutBuilder(builder: (context, constraints) {
                          final wide = constraints.maxWidth > 900;
                          final columns = wide ? 2 : 1;
                          final childAspect = wide ? 1.45 : 1.6;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: columns,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 48,
                            childAspectRatio: childAspect,
                            children: [
                              Center(child: ProductCard(productId: 'signature_hoodie')),
                              Center(child: ProductCard(productId: 'signature_cap')),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: const [
                        ProductCard(
                          productId: 'placeholder_1',
                          title: 'Placeholder Product 1',
                          price: '£10.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          productId: 'placeholder_2',
                          title: 'Placeholder Product 2',
                          price: '£15.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          productId: 'placeholder_3',
                          title: 'Placeholder Product 3',
                          price: '£20.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          productId: 'placeholder_4',
                          title: 'Placeholder Product 4',
                          price: '£25.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 28),

                    //centered "View all" button
                    Center(
                      child: ElevatedButton(
                        onPressed: placeholderCallbackForButtons,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4d2963),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Our Range Section 
            Container(
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000), // 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'OUR RANGE',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[800],
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        LayoutBuilder(builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final cross = width > 900 ? 4 : 2;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: cross,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 1,
                            children: [
                              // Clothing
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/product', arguments: 'placeholder_1'),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                    ),
                                    Container(color: Color.fromRGBO(0, 0, 0, 0.45)),
                                    const Center(
                                      child: Text(
                                        'Clothing',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Merchandise
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/product', arguments: 'placeholder_2'),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                    ),
                                    Container(color: Color.fromRGBO(0, 0, 0, 0.45)),
                                    Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: const Text(
                                          'Merchandise',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Graduation
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/product', arguments: 'placeholder_3'),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                    ),
                                    Container(color: Color.fromRGBO(0, 0, 0, 0.45)),
                                    const Center(
                                      child: Text(
                                        'Graduation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // SALE
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/product', arguments: 'placeholder_4'),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                                    ),
                                    Container(color: Color.fromRGBO(0, 0, 0, 0.45)),
                                    const Center(
                                      child: Text(
                                        'SALE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Add a Personal Touch Section
            Container(
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 700;
                      return isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // image on top for mobile
                                SizedBox(
                                  height: 320,
                                  child: _NetworkImageWithFallback(
                                    key: const ValueKey('printshack-mobile'),
                                    url: 'https://shop.upsu.net/cdn/shop/files/upsu_printshack_1024x1024.jpg?v=1',
                                    altUrl:
                                        'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Add a Personal Touch',
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'First add your item of clothing to your cart then click below to add your text! One line of text contains 10 characters!',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: placeholderCallbackForButtons,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4d2963),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  ),
                                  child: const Text('CLICK HERE TO ADD TEXT!', style: TextStyle(letterSpacing: 1)),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                // left text column
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 24.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add a Personal Touch',
                                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'First add your item of clothing to your cart then click below to add your text! One line of text contains 10 characters!',
                                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 28),
                                        ElevatedButton(
                                          onPressed: placeholderCallbackForButtons,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF4d2963),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                          ),
                                          child: const Text('CLICK HERE TO ADD TEXT!', style: TextStyle(letterSpacing: 1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // right image
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 340,
                                    child: _NetworkImageWithFallback(
                                      key: const ValueKey('printshack-desktop'),
                                      url: 'https://shop.upsu.net/cdn/shop/files/upsu_printshack_1024x1024.jpg?v=1',
                                      altUrl:
                                          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                    ),
                                   ),
                                 ),
                              ],
                            );
                    }),
                  ),
                ),
              ),
            ),

            

            // Footer 
            Container(
              width: double.infinity,
              color: const Color(0xFFFAFAFA),
              child: LayoutBuilder(builder: (context, constraints) {
                final w = constraints.maxWidth;
                final isMobile = w < 700;
                final horizontalPadding = isMobile ? 12.0 : 40.0;

                final headingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF333333));
                final bodyStyle = TextStyle(fontSize: 14, color: const Color(0xFF4A4A4A), height: 1.35);
                final strongStyle = bodyStyle.copyWith(fontWeight: FontWeight.w700);

                Widget openingHours = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opening Hours', style: headingStyle),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: const Icon(Icons.ac_unit, size: 16, color: Color(0xFF4A4A4A)),
                          ),
                          const TextSpan(text: ' '),
                          const TextSpan(text: 'Winter Break Closure Dates'),
                          const TextSpan(text: ' '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: const Icon(Icons.ac_unit, size: 16, color: Color(0xFF4A4A4A)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Closing 4pm 19/12/2025', style: strongStyle),
                    Text('Reopening 10am 05/01/2026', style: strongStyle),
                    const SizedBox(height: 8),
                    Text('Last post date: 12pm on 18/12/2025', style: strongStyle),
                    const SizedBox(height: 12),
                    Text('-----------------------------', style: bodyStyle),
                    const SizedBox(height: 10),
                    Text('(Term Time)', style: strongStyle),
                    const SizedBox(height: 6),
                    Text('Monday - Friday 10am - 4pm', style: bodyStyle),
                    const SizedBox(height: 8),
                    Text('(Outside of Term Time / Consolidation Weeks)', style: bodyStyle),
                    Text('Monday - Friday 10am - 3pm', style: bodyStyle),
                    const SizedBox(height: 8),
                    Text('Purchase online 24/7', style: strongStyle),
                  ],
                );

                Widget helpColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Help and Information', style: headingStyle),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: placeholderCallbackForButtons,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        foregroundColor: const Color(0xFF333333),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text('Search', textAlign: TextAlign.left),
                    ),
                    TextButton(
                      onPressed: placeholderCallbackForButtons,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        foregroundColor: const Color(0xFF333333),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text(
                        'Terms & Conditions of Sale',
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: placeholderCallbackForButtons,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        foregroundColor: const Color(0xFF333333),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text('Policy', textAlign: TextAlign.left),
                    ),
                  ],
                );
 
                Widget subscribeColumn = Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Latest Offers', style: headingStyle),
                     const SizedBox(height: 12),
                     Row(
                       children: [
                         Expanded(
                           child: TextField(
                             decoration: InputDecoration(
                               hintText: 'Email address',
                               filled: true,
                               fillColor: Colors.white,
                               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                             ),
                             style: const TextStyle(fontSize: 14),
                           ),
                         ),
                         const SizedBox(width: 8),
                         ElevatedButton(
                           onPressed: placeholderCallbackForButtons,
                           style: ElevatedButton.styleFrom(
                             backgroundColor: const Color(0xFF4d2963),
                             foregroundColor: Colors.white,
                             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                           ),
                           child: const Text('SUBSCRIBE', style: TextStyle(letterSpacing: 1, fontSize: 13)),
                         ),
                       ],
                     ),
                     const SizedBox(height: 8),
                     Text('Sign up for exclusive offers and updates.', style: bodyStyle),
                   ],
                 );
 
                 return Column(
                   children: [
                     Padding(
                       padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: horizontalPadding),
                       child: ConstrainedBox(
                         constraints: const BoxConstraints(maxWidth: 1200),
                         child: isMobile
                             ? Column(
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children: [
                                   openingHours,
                                   const SizedBox(height: 20),
                                   helpColumn,
                                   const SizedBox(height: 18),
                                   subscribeColumn,
                                 ],
                               )
                             : Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Expanded(flex: 4, child: openingHours),
                                   const SizedBox(width: 40),
                                   Expanded(flex: 3, child: helpColumn),
                                   const SizedBox(width: 40),
                                   Expanded(flex: 4, child: subscribeColumn),
                                 ],
                               ),
                       ),
                     ),

                    const Divider(height: 1, color: Color(0xFFE0E0E0)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: isMobile
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(icon: const Icon(Icons.facebook), onPressed: placeholderCallbackForButtons, color: Colors.black54),
                                      IconButton(icon: const Icon(Icons.share), onPressed: placeholderCallbackForButtons, color: Colors.black54),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('© 2025, upsu-store  Powered by Shopify', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    children: const [
                                      _PaymentBadge(label: ' Pay'),
                                      _PaymentBadge(label: 'Discover'),
                                      _PaymentBadge(label: 'G Pay'),
                                      _PaymentBadge(label: 'Mastercard'),
                                      _PaymentBadge(label: 'Visa'),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(icon: const Icon(Icons.facebook), onPressed: placeholderCallbackForButtons, color: Colors.black54),
                                      IconButton(icon: const Icon(Icons.share), onPressed: placeholderCallbackForButtons, color: Colors.black54),
                                    ],
                                  ),
                                  const Expanded(child: Center(child: Text('© 2025, upsu-store  Powered by Shopify', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13)))),
                                  Row(
                                    children: const [
                                      _PaymentBadge(key: ValueKey('apple-pay'), label: ' Pay'),
                                      SizedBox(width: 8),
                                      _PaymentBadge(key: ValueKey('discover'), label: 'Discover'),
                                      SizedBox(width: 8),
                                      _PaymentBadge(key: ValueKey('gpay'), label: 'G Pay'),
                                      SizedBox(width: 8),
                                      _PaymentBadge(key: ValueKey('mastercard'), label: 'Mastercard'),
                                      SizedBox(width: 8),
                                      _PaymentBadge(key: ValueKey('visa'), label: 'Visa'),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _controller = PageController();
  late Timer _timer;
  bool _paused = false;
  int _current = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Music Sale — Vinyl & More',
      'subtitle': 'Discover discounted records, merch and audio gear',
      'image': 'https://res.cloudinary.com/dl650ouuv/image/upload/v1764882182/musicsalecollection_bibsom.jpg',
      'button': 'SHOP MUSIC',
      'target': 'music'
    },
    {
      'title': 'Make university life easier',
      'subtitle': 'Support services, events and advice for students',
      'image':
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      'button': 'EXPLORE'
    },
    {
      'title': 'Join the community',
      'subtitle': 'Clubs, societies and ways to get involved',
      'image':
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      'button': 'LEARN MORE'
    },
    {
      'title': 'Shop essentials here',
      'subtitle': 'Everything you need for campus life',
      'image':
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      'button': 'BROWSE PRODUCTS'
    },
  ];

  Duration get _autoPlayDelay => const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(_autoPlayDelay, (timer) {
      if (_paused) return;
      final next = (_current + 1) % _slides.length;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _goTo(int index) {
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _previous() {
    final prev = (_current - 1 + _slides.length) % _slides.length;
    _goTo(prev);
  }

  void _next() {
    final next = (_current + 1) % _slides.length;
    _goTo(next);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        children: [
          // Background pages (images)
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            children: _slides
                .map((s) => _NetworkImageWithFallback(url: s['image']!))
                .toList(),
          ),

          // Center overlay with text and CTA
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _slides[_current]['title']!,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 8, color: Colors.black45, offset: Offset(0, 2))
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _slides[_current]['subtitle'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(255, 255, 255, 0.95),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final s = _slides[_current];
                      // If the slide has a specific target, navigate accordingly
                      if (s['target'] == 'music') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SaleCollection()));
                      } else if (s['route'] != null) {
                        Navigator.pushNamed(context, s['route']!);
                      } else {
                        // default / no-op
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      _slides[_current]['button']!,
                      style: const TextStyle(letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left / Right nav buttons (center vertical)
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 36,
                color: Colors.white70,
                icon: const Icon(Icons.chevron_left),
                onPressed: _previous,
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 36,
                color: Colors.white70,
                icon: const Icon(Icons.chevron_right),
                onPressed: _next,
              ),
            ),
          ),

          // Bottom controls: indicators + pause/play
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // indicators
                Row(
                  children: List.generate(_slides.length, (i) {
                    final active = i == _current;
                    return GestureDetector(
                      onTap: () => _goTo(i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: active ? 12 : 8,
                        height: active ? 12 : 8,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                // pause / play button
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    icon: Icon(_paused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white),
                    onPressed: _togglePause,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String? productId;
  final String? title;
  final String? price;
  final String? imageUrl;

  const ProductCard({
    super.key,
    this.productId,
    this.title,
    this.price,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final Product? prod = (productId != null && productRegistry.containsKey(productId)) ? productRegistry[productId] : null;
    final displayTitle = prod?.title ?? title ?? 'Product';
    final displayPrice = prod != null ? '£${prod.price.toStringAsFixed(2)}' : (price ?? '');
    final displayImage = prod?.images.isNotEmpty == true ? prod!.images.first : (imageUrl ?? '');

    return GestureDetector(
      onTap: () {
        if (productId != null) Navigator.pushNamed(context, '/product', arguments: productId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: displayImage.isNotEmpty
                ? Image.network(
                    displayImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(color: Colors.grey[300]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                displayTitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                displayPrice,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetworkImageWithFallback extends StatelessWidget {
  final String url;
  final String? altUrl;
  const _NetworkImageWithFallback({
    super.key,
    required this.url,
    this.altUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (altUrl != null) {
          // try alternate image
          return Image.network(
            altUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (c, e, s) => Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
            ),
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
        );
      },
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String label;
  const _PaymentBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
    );
  }
}
