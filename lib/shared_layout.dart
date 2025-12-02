import 'package:flutter/material.dart';

/// Shared header used across pages.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  void _openBurgerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (c) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(c);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              ),
              ListTile(
                title: const Text('Shop'),
                onTap: () {
                  Navigator.pop(c);
                },
              ),
              ListTile(
                title: const Text('The Print Shack'),
                onTap: () {
                  Navigator.pop(c);
                },
              ),
              ListTile(
                title: const Text('SALE!'),
                onTap: () {
                  Navigator.pop(c);
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(c);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                title: const Text('UPSU.net'),
                onTap: () {
                  Navigator.pop(c);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // Thin purple top line + main header
        Column(
          children: [
            Container(
              height: 6,
              color: const Color(0xFF4d2963),
            ),
            Container(
              height: 96,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LayoutBuilder(builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 700;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 160,
                        minWidth: 48,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GestureDetector(
                          onTap: () => _navigateToHome(context),
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
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Center nav or burger
                    Flexible(
                      fit: FlexFit.loose,
                      child: isMobile
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
                                onPressed: () => _openBurgerMenu(context),
                                padding: const EdgeInsets.all(6),
                              ),
                            )
                          : Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 700),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () => _navigateToHome(context),
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
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text('Shop', style: TextStyle(fontSize: 16)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text('The Print Shack', style: TextStyle(fontSize: 16)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text('SALE!', style: TextStyle(fontSize: 16)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () => _navigateToAbout(context),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        foregroundColor: Colors.black,
                                      ),
                                      child: const Text('About', style: TextStyle(fontSize: 16)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {},
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

                    // Right-side icons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search, size: 26, color: Colors.black87),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.person_outline, size: 26, color: Colors.black87),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}

/// Shared footer used across pages.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  void _placeholder() {}

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onPressed: _placeholder,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                foregroundColor: const Color(0xFF333333),
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text('Search', textAlign: TextAlign.left),
            ),
            TextButton(
              onPressed: _placeholder,
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
              onPressed: _placeholder,
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
                  onPressed: _placeholder,
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
                              IconButton(icon: const Icon(Icons.facebook), onPressed: _placeholder, color: Colors.black54),
                              IconButton(icon: const Icon(Icons.share), onPressed: _placeholder, color: Colors.black54),
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
                              IconButton(icon: const Icon(Icons.facebook), onPressed: _placeholder, color: Colors.black54),
                              IconButton(icon: const Icon(Icons.share), onPressed: _placeholder, color: Colors.black54),
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