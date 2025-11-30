import 'package:flutter/material.dart';
import 'package:union_shop/product_page.dart';
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
      // When navigating to '/product', build and return the ProductPage
      // In your browser, try this link: http://localhost:49856/#/product
      routes: {'/product': (context) => const ProductPage()},
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            // Top sale banner 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF4d2963),
              child: const Text(
                'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Header 
            Column(
              children: [
                // Thin purple top line
                Container(
                  height: 6,
                  color: const Color(0xFF4d2963),
                ),
                Container(
                  height: 96,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      // Logo (left)
                      GestureDetector(
                        onTap: () => navigateToHome(context),
                        child: Image.network(
                          'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                          height: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Center navigation 
                      Expanded(
                        child: Transform.translate(
                          offset: const Offset(-20, 0),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 700),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Home (active with underline)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () => navigateToHome(context),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text('Home', style: TextStyle(fontSize: 16)),
                                      ),
                                      Container(height: 2, width: 36, color: Colors.black),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  // Shop 
                                  TextButton(
                                    onPressed: placeholderCallbackForButtons,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('Shop', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  // The Print Shack 
                                  TextButton(
                                    onPressed: placeholderCallbackForButtons,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('The Print Shack', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: placeholderCallbackForButtons,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('SALE!', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: placeholderCallbackForButtons,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('About', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: placeholderCallbackForButtons,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text('UPSU.net', style: TextStyle(fontSize: 16)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Right-side icons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, size: 28, color: Colors.black87),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                            onPressed: placeholderCallbackForButtons,
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_outline, size: 28, color: Colors.black87),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                            onPressed: placeholderCallbackForButtons,
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.black87),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                            onPressed: placeholderCallbackForButtons,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Hero Section
            HeroCarousel(),

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
                          title: 'Placeholder Product 1',
                          price: '£10.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          title: 'Placeholder Product 2',
                          price: '£15.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          title: 'Placeholder Product 3',
                          price: '£20.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                        ProductCard(
                          title: 'Placeholder Product 4',
                          price: '£25.00',
                          imageUrl:
                              'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.all(24),
              child: const Text(
                'Placeholder Footer',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      'title': "What's your next move...",
      'subtitle': 'Are you with us?',
      'image':
          'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      'button': 'FIND YOUR STUDENT ACCOMMODATION'
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
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
                  ),
                  // Dark overlay
                  Container(
                    color: Colors.black.withOpacity(0.45),
                  ),
                ],
              );
            },
          ),

          // Center content (title + subtitle + button)
          Positioned.fill(
            child: Center(
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
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.95),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // dummy action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
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
                    color: Colors.black.withOpacity(0.5),
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
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
