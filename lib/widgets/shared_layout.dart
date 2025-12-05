import 'package:flutter/material.dart';
import 'package:union_shop/models/cart.dart';
import 'package:union_shop/pages/sale_collection.dart';
import 'package:union_shop/pages/theprintshack_page.dart';
import 'package:union_shop/pages/collections_page.dart';
import 'package:union_shop/pages/autumn_collection.dart';

/// Shared header used across pages.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  // The old bottom-sheet burger menu was replaced by a popup menu for mobile.
  // Kept the shop bottom-sheet helper for reuse (if desired).

  // Shop bottom sheet helper removed; replaced by popup menu for mobile.

  // The shop-popup helper was inlined into the mobile menu handler to avoid
  // passing a BuildContext into an async function (which triggers the
  // use_build_context_synchronously analyzer warning). If you want a reusable
  // helper in future, prefer passing only non-context objects (NavigatorState,
  // render box, sizes) captured synchronously from the calling scope.

  // Sheet-style helper removed; shop submenu now uses a popup menu for mobile

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
            LayoutBuilder(builder: (context, constraints) {
              final isMobile = constraints.maxWidth <= 700; 
              final double logoHeight = isMobile ? 40.0 : 72.0;
              final double leftPad = 12.0;
              final double rightPad = isMobile ? 6.0 : 12.0;
              final double centerShift = isMobile ? 0.0 : -80.0;
              // Determine current route so we can mark the active nav item.
              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              final bool isHomeRoute = currentRoute == '/';
              final bool isAboutRoute = currentRoute == '/about';

                    return Container(
                height: 96,
                color: Colors.white,
                padding: EdgeInsets.only(left: leftPad, right: rightPad),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button (shown when there is a route to pop)
                    if (Navigator.of(context).canPop())
                      Padding(
                        padding: EdgeInsets.only(right: isMobile ? 6.0 : 12.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black87,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),

                    // Logo
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? 160 : 280,
                        minWidth: 48,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _navigateToHome(context),
                          child: Image.network(
                            'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                            height: logoHeight,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                width: logoHeight,
                                height: logoHeight,
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    if (!isMobile) const SizedBox(width: 8),

                    Expanded(
                      child: isMobile
                          ? const SizedBox.shrink()
                          : Center(
                              child: Transform.translate(
                                offset: Offset(centerShift, 0),
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
                                          Container(
                                            height: 2,
                                            width: 36,
                                            color: isHomeRoute ? Colors.black : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),

                                      PopupMenuButton<String>(
                                        offset: const Offset(0, 56),
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'all_collections') {
                                            Navigator.pushNamed(context, '/collections');
                                            return;
                                          }
                                          if (value.startsWith('collection:')) {
                                            final idx = int.tryParse(value.split(':').last) ?? -1;
                                            if (idx >= 0 && idx < CollectionsPage.collections.length) {
                                              CollectionsPage.openCollection(context, CollectionsPage.collections[idx]);
                                            }
                                          }
                                        },
                                        itemBuilder: (ctx) {
                                          final screenW = MediaQuery.of(ctx).size.width;
                                          final menuWidth = screenW > 1000 ? 320.0 : 300.0;
                                          final cols = CollectionsPage.collections;
                                          final items = <PopupMenuEntry<String>>[];
                                          for (var i = 0; i < cols.length; i++) {
                                            final title = cols[i]['title'] ?? 'Collection';
                                            // small playful decorations for the first three collections
                                            final String? deco = i == 0
                                                ? '🎃' // Autumn
                                                : i == 1
                                                    ? '🎵' // Music
                                                    : i == 2
                                                        ? '🛍️' // All products
                                                        : null;
                                            items.add(PopupMenuItem(
                                              value: 'collection:$i',
                                              child: SizedBox(
                                                width: menuWidth,
                                                child: ListTile(
                                                  title: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Flexible(child: Text(title)),
                                                      if (deco != null) ...[
                                                        const SizedBox(width: 8),
                                                        Text(deco, style: const TextStyle(fontSize: 18)),
                                                      ],
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ));
                                          }
                                          items.add(const PopupMenuDivider());
                                          items.add(PopupMenuItem(value: 'all_collections', child: SizedBox(width: menuWidth, child: ListTile(title: const Text('All Collections'), contentPadding: EdgeInsets.zero))));
                                          return items;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text('Shop', style: TextStyle(fontSize: 16, color: Colors.black)),
                                              SizedBox(width: 4),
                                              Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThePrintShackPage())),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text('The Print Shack', style: TextStyle(fontSize: 16)),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SaleCollection())),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text('SALE!', style: TextStyle(fontSize: 16)),
                                      ),
                                      const SizedBox(width: 8),

                                      // About
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                            onPressed: () => _navigateToAbout(context),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              foregroundColor: Colors.black,
                                            ),
                                            child: const Text('About', style: TextStyle(fontSize: 16)),
                                          ),
                                          Container(
                                            height: 2,
                                            width: 48,
                                            color: isAboutRoute ? Colors.black : Colors.transparent,
                                          ),
                                        ],
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
                    ),

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
                        // Cart icon with live badge showing total items
                        AnimatedBuilder(
                          animation: globalCart,
                          builder: (ctx, _) {
                            final count = globalCart.totalItems;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shopping_bag_outlined, size: 26, color: Colors.black87),
                                  padding: const EdgeInsets.all(6),
                                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  onPressed: () => Navigator.pushNamed(ctx, '/cart'),
                                ),
                                if (count > 0)
                                  Positioned(
                                    right: 6,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFF4d2963), borderRadius: BorderRadius.circular(12)),
                                      constraints: const BoxConstraints(minWidth: 20, minHeight: 16),
                                      child: Text('$count', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        // On mobile place the burger/menu button at the very right
                        if (isMobile)
                          PopupMenuButton<String>(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
                            onSelected: (value) {
                              final navigator = Navigator.of(context);
                              switch (value) {
                                case 'home':
                                  navigator.pushNamedAndRemoveUntil('/', (route) => false);
                                  break;
                                case 'shop':
                                  // Show a submenu of current collections (mobile)
                                  final navigator = Navigator.of(context);
                                  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
                                  final screenW = MediaQuery.of(context).size.width;
                                  // Give mobile a bit more breathing room and stay inset from edges
                                  final menuWidth = (screenW - 32).clamp(260.0, 360.0);
                                  final RelativeRect position = overlay != null
                                      ? RelativeRect.fromLTRB(overlay.size.width - (menuWidth + 16), kToolbarHeight + 8, 16, 0)
                                      : const RelativeRect.fromLTRB(0, 80, 0, 0);

                                  final cols = CollectionsPage.collections;
                                  final items = <PopupMenuEntry<String>>[];
                                  for (var i = 0; i < cols.length; i++) {
                                    final title = cols[i]['title'] ?? 'Collection';
                                    final String? deco = i == 0
                                        ? '🎃'
                                        : i == 1
                                            ? '🎵'
                                            : i == 2
                                                ? '🛍️'
                                                : null;
                                    items.add(PopupMenuItem(
                                      value: 'collection:$i',
                                      child: SizedBox(
                                        width: menuWidth,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: const Color(0xFF4d2963),
                                            child: deco != null
                                                ? Text(deco, style: const TextStyle(fontSize: 18))
                                                : const Icon(Icons.collections, color: Colors.white, size: 18),
                                          ),
                                          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.black54),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        ),
                                      ),
                                    ));
                                  }
                                  items.add(const PopupMenuDivider());
                                  items.add(PopupMenuItem(
                                    value: 'all_collections',
                                    child: SizedBox(
                                      width: menuWidth,
                                      child: ListTile(
                                        leading: CircleAvatar(radius: 18, backgroundColor: const Color(0xFF4d2963), child: const Icon(Icons.grid_view, color: Colors.white, size: 18)),
                                        title: const Text('All Collections', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      ),
                                    ),
                                  ));

                                  showMenu<String>(context: context, position: position, items: items).then((selected) {
                                    if (selected == null) return;
                                    if (selected == 'all_collections') {
                                      navigator.pushNamed('/collections');
                                      return;
                                    }
                                    if (selected.startsWith('collection:')) {
                                      final idx = int.tryParse(selected.split(':').last) ?? -1;
                                      if (idx >= 0 && idx < cols.length) {
                                        final title = (cols[idx]['title'] ?? '').trim();
                                        if (title == 'Autumn Favourites') {
                                          navigator.push(MaterialPageRoute(builder: (_) => const AutumnCollection()));
                                        } else if (title == 'Music Sale collection') {
                                          navigator.push(MaterialPageRoute(builder: (_) => const SaleCollection()));
                                        } else if (title == 'All Products') {
                                          navigator.pushNamed('/all-products');
                                        } else {
                                          navigator.pushNamed('/product');
                                        }
                                      }
                                    }
                                  });

                                  break;
                                case 'printshack':
                                  Future.microtask(() => navigator.push(MaterialPageRoute(builder: (_) => const ThePrintShackPage())));
                                  break;
                                case 'sale':
                                  Future.microtask(() => navigator.push(MaterialPageRoute(builder: (_) => const SaleCollection())));
                                  break;
                                case 'about':
                                  navigator.pushNamed('/about');
                                  break;
                                case 'upsu':
                                  // placeholder
                                  break;
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'home', child: Text('Home')),
                              const PopupMenuItem(value: 'shop', child: Text('Shop')),
                              const PopupMenuItem(value: 'printshack', child: Text('The Print Shack')),
                              const PopupMenuItem(value: 'sale', child: Text('SALE!')),
                              const PopupMenuItem(value: 'about', child: Text('About')),
                              const PopupMenuItem(value: 'upsu', child: Text('UPSU.net')),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            // Thin divider at the bottom of the header
            Container(height: 1, color: const Color(0xFFE0E0E0)),
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
      color: const Color(0xFFF2F2F2),
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