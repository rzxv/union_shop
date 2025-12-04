import 'package:flutter/material.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/orders.dart';
import 'package:union_shop/shared_layout.dart';

class CartPage extends StatefulWidget {
  final Widget header;
  final Widget footer;

  const CartPage({super.key, this.header = const AppHeader(), this.footer = const AppFooter()});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final Map<String, TextEditingController> _qtyControllers;

  @override
  void initState() {
    super.initState();
    _qtyControllers = {};
    globalCart.addListener(_onCartChanged);
  }

  void _onCartChanged() => setState(() {});

  @override
  void dispose() {
    globalCart.removeListener(_onCartChanged);
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllersForItems(List<CartItem> items) {
    final existingKeys = _qtyControllers.keys.toSet();
    final itemKeys = items.map((e) => e.key).toSet();
    for (final k in existingKeys.difference(itemKeys)) {
      _qtyControllers.remove(k)?.dispose();
    }
    for (final it in items) {
      _qtyControllers.putIfAbsent(it.key, () => TextEditingController(text: it.quantity.toString()));
      final ctrl = _qtyControllers[it.key]!;
      if (ctrl.text != it.quantity.toString()) ctrl.text = it.quantity.toString();
    }
  }

  void _checkout() {
    final count = globalCart.totalItems;
    if (count == 0) return;
    final orderItems = globalCart.items
        .map((ci) => OrderItem(id: ci.id, title: ci.title, color: ci.color, size: ci.size, quantity: ci.quantity))
        .toList(growable: false);
    final order = Order(id: DateTime.now().millisecondsSinceEpoch.toString(), placedAt: DateTime.now(), items: orderItems);
    globalOrders.add(order);
    globalCart.clear();
    Navigator.pushNamed(context, '/order-confirmation', arguments: order.id);
  }

  void _updateQuantities() {
    for (final entry in _qtyControllers.entries) {
      final key = entry.key;
      final text = entry.value.text.trim();
      final q = int.tryParse(text) ?? 0;
      if (q <= 0) {
        globalCart.remove(key);
      } else {
        globalCart.updateQuantity(key, q);
      }
    }
  }

  void _placeOrderAndNavigate() => _checkout();

  @override
  Widget build(BuildContext context) {
    final items = globalCart.items;
    _ensureControllersForItems(items);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.header,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Center(child: Text('Your cart', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800))),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/collections'),
                        child: const Text('Continue shopping', style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF4d2963))),
                      ),
                    ),
                    const SizedBox(height: 18),

                    LayoutBuilder(builder: (ctx, constraints) {
                      final isMobile = constraints.maxWidth < 700;

                      if (items.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(child: Text('Your cart is empty')),
                        );
                      }

                      if (!isMobile) {
                        // Desktop / table layout
                        return Column(
                          children: [
                            Row(
                              children: const [
                                Expanded(flex: 4, child: Text('Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Center(child: Text('Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
                                Expanded(flex: 1, child: Center(child: Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
                                Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
                              ],
                            ),
                            const Divider(height: 24),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (ctx, i) {
                                final it = items[i];
                                final ctrl = _qtyControllers[it.key]!;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          if (it.image != null)
                                            Image.network(it.image!, width: 84, height: 84, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[300], width: 84, height: 84)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(it.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                                const SizedBox(height: 6),
                                                Text('Color: ${it.color}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                                Text('Size: ${it.size}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                                TextButton(
                                                  key: ValueKey('remove-${it.key}'),
                                                  onPressed: () => globalCart.remove(it.key),
                                                  child: const Text('Remove', style: TextStyle(color: Color(0xFF4d2963))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 1, child: Center(child: Text('£${it.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)))),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: SizedBox(
                                          width: 140,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                key: ValueKey('dec-${it.key}'),
                                                onPressed: () => globalCart.updateQuantity(it.key, it.quantity - 1),
                                                style: OutlinedButton.styleFrom(minimumSize: const Size(36, 36), padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                child: const Icon(Icons.remove, size: 18),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 56,
                                                child: TextField(
                                                  controller: ctrl,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 18),
                                                  keyboardType: TextInputType.number,
                                                  decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.zero), contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8)),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              OutlinedButton(
                                                key: ValueKey('inc-${it.key}'),
                                                onPressed: () => globalCart.updateQuantity(it.key, it.quantity + 1),
                                                style: OutlinedButton.styleFrom(minimumSize: const Size(36, 36), padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                child: const Icon(Icons.add, size: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text('£${(it.price * it.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)))),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Actions and subtotal area for desktop
                            LayoutBuilder(builder: (ctx2, c2) {
                              final actionButtonWidth = 180.0;
                              final subtotal = items.fold<double>(0.0, (p, e) => p + e.price * e.quantity);
                              final subtotalWidget = Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Subtotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  Text('£${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  const Text('Tax included and shipping calculated at checkout', style: TextStyle(color: Colors.black54)),
                                ],
                              );

                              return Row(
                                children: [
                                  const Expanded(child: SizedBox.shrink()),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(padding: const EdgeInsets.only(top: 12), child: subtotalWidget),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          alignment: WrapAlignment.end,
                                          spacing: 20,
                                          children: [
                                            SizedBox(
                                              width: actionButtonWidth,
                                              child: OutlinedButton(
                                                onPressed: _updateQuantities,
                                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4d2963)), foregroundColor: const Color(0xFF4d2963), padding: const EdgeInsets.symmetric(vertical: 14), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                child: const Text('UPDATE', style: TextStyle(letterSpacing: 1.2)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: actionButtonWidth,
                                              child: ElevatedButton(
                                                key: const ValueKey('checkout'),
                                                onPressed: items.isEmpty ? null : _placeOrderAndNavigate,
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), textStyle: const TextStyle(fontWeight: FontWeight.w700), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                child: const Text('CHECK OUT'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: actionButtonWidth,
                                              child: ElevatedButton(
                                                onPressed: _placeOrderAndNavigate,
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                child: const Text('G Pay'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        );
                      }

                      // mobile layout: stacked items then stacked full-width actions
                      return Column(
                        children: [
                          Column(
                            children: List.generate(items.length, (i) {
                              final it = items[i];
                              final ctrl = _qtyControllers[it.key]!;
                              return Column(
                                children: [
                                  const Divider(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (it.image != null)
                                        Image.network(it.image!, width: 84, height: 84, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[300], width: 84, height: 84)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(it.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 6),
                                            Text('Color: ${it.color} • Size: ${it.size}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('£${it.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                                                SizedBox(
                                                  width: 140,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      OutlinedButton(
                                                        key: ValueKey('dec-${it.key}'),
                                                        onPressed: () => globalCart.updateQuantity(it.key, it.quantity - 1),
                                                        style: OutlinedButton.styleFrom(minimumSize: const Size(36, 36), padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                        child: const Icon(Icons.remove, size: 18),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      SizedBox(width: 56, child: TextField(controller: ctrl, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18), keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.zero), contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8)))),
                                                      const SizedBox(width: 8),
                                                      OutlinedButton(
                                                        key: ValueKey('inc-${it.key}'),
                                                        onPressed: () => globalCart.updateQuantity(it.key, it.quantity + 1),
                                                        style: OutlinedButton.styleFrom(minimumSize: const Size(36, 36), padding: EdgeInsets.zero, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                                        child: const Icon(Icons.add, size: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text('£${(it.price * it.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                                              ],
                                            ),
                                            TextButton(key: ValueKey('remove-${it.key}'), onPressed: () => globalCart.remove(it.key), child: const Text('Remove', style: TextStyle(color: Color(0xFF4d2963)))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),

                          const SizedBox(height: 20),

                          // subtotal + actions for mobile
                          Builder(builder: (ctx2) {
                            final subtotal = items.fold<double>(0.0, (p, e) => p + e.price * e.quantity);
                            final subtotalWidget = Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Subtotal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text('£${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                const Text('Tax included and shipping calculated at checkout', style: TextStyle(color: Colors.black54)),
                              ],
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: subtotalWidget),
                                SizedBox(
                                  height: 52,
                                  child: OutlinedButton(
                                    onPressed: _updateQuantities,
                                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4d2963)), foregroundColor: const Color(0xFF4d2963), padding: const EdgeInsets.symmetric(vertical: 14), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                    child: const Text('UPDATE', style: TextStyle(letterSpacing: 1.2)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    key: const ValueKey('checkout'),
                                    onPressed: items.isEmpty ? null : _placeOrderAndNavigate,
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), textStyle: const TextStyle(fontWeight: FontWeight.w700), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                    child: const Text('CHECK OUT'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _placeOrderAndNavigate,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                                    child: const Text('G Pay'),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    }),

                    const SizedBox(height: 40),
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
