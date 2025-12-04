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
  final Map<String, TextEditingController> _qtyControllers = {};
  @override
  void initState() {
    super.initState();
    // listen to globalCart to update UI
    globalCart.addListener(_onCartChanged);
  }

  void _onCartChanged() => setState(() {});

  @override
  void dispose() {
    globalCart.removeListener(_onCartChanged);
    // dispose controllers
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllersForItems(List<CartItem> items) {
    // create controllers for visible items, keep existing ones for keys present
    final existingKeys = _qtyControllers.keys.toSet();
    final itemKeys = items.map((e) => e.key).toSet();

    // remove controllers for items no longer present
    for (final k in existingKeys.difference(itemKeys)) {
      _qtyControllers.remove(k)?.dispose();
    }

    // ensure controller for each item
    for (final it in items) {
      _qtyControllers.putIfAbsent(it.key, () => TextEditingController(text: it.quantity.toString()));
      // keep controller text in sync
      final ctrl = _qtyControllers[it.key]!;
      if (ctrl.text != it.quantity.toString()) ctrl.text = it.quantity.toString();
    }
  }

  void _checkout() {
    // Simple checkout that clears the cart and shows confirmation
    final count = globalCart.totalItems;
    if (count == 0) return;
    // Build an Order from the current cart contents
    final orderItems = globalCart.items.map((ci) => OrderItem(
      id: ci.id,
      title: ci.title,
      color: ci.color,
      size: ci.size,
      quantity: ci.quantity,
    )).toList(growable: false);

    final order = Order(id: DateTime.now().millisecondsSinceEpoch.toString(), placedAt: DateTime.now(), items: orderItems);
    globalOrders.add(order);

    // Clear the cart after recording the order
    globalCart.clear();

    // Navigate to order confirmation page with the order id
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

  void _placeOrderAndNavigate() {
    // reuse checkout logic
    _checkout();
  }

  @override
  Widget build(BuildContext context) {
    final items = globalCart.items;
    _ensureControllersForItems(items);
    return Scaffold(
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
                    const Center(child: Text('Your cart', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Continue shopping', style: TextStyle(decoration: TextDecoration.underline, color: Color(0xFF4d2963))),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header row
                    LayoutBuilder(builder: (ctx, constraints) {
                      final isMobile = constraints.maxWidth < 700;
                      if (items.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(child: Text('Your cart is empty')),
                        );
                      }

                      // desktop/table layout
                      if (!isMobile) {
                        return Column(
                          children: [
                            Row(
                              children: const [
                                Expanded(flex: 4, child: Text('Product')),
                                Expanded(flex: 1, child: Text('Price')),
                                Expanded(flex: 1, child: Text('Quantity')),
                                Expanded(flex: 1, child: Text('Total')),
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
                                            Image.network(it.image!, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(color: Colors.grey[300], width:72,height:72)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(it.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                                    Expanded(flex: 1, child: Text('£${it.price.toStringAsFixed(2)}')),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              key: ValueKey('dec-${it.key}'),
                                              icon: const Icon(Icons.remove),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              onPressed: () => globalCart.updateQuantity(it.key, it.quantity - 1),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: ctrl,
                                                keyboardType: TextInputType.number,
                                                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                                              ),
                                            ),
                                            IconButton(
                                              key: ValueKey('inc-${it.key}'),
                                              icon: const Icon(Icons.add),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              onPressed: () => globalCart.updateQuantity(it.key, it.quantity + 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(flex: 1, child: Text('£${(it.price * it.quantity).toStringAsFixed(2)}')),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }

                      // mobile layout
                      return Column(
                        children: List.generate(items.length, (i) {
                          final it = items[i];
                          final ctrl = _qtyControllers[it.key]!;
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (it.image != null)
                                    Image.network(it.image!, width: 84, height: 84, fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(color: Colors.grey[300], width:84,height:84)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(it.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 6),
                                        Text('Color: ${it.color} • Size: ${it.size}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('£${it.price.toStringAsFixed(2)}'),
                                            SizedBox(
                                              width: 120,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    key: ValueKey('dec-${it.key}'),
                                                    icon: const Icon(Icons.remove),
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                    onPressed: () => globalCart.updateQuantity(it.key, it.quantity - 1),
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      controller: ctrl,
                                                      keyboardType: TextInputType.number,
                                                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    key: ValueKey('inc-${it.key}'),
                                                    icon: const Icon(Icons.add),
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                    onPressed: () => globalCart.updateQuantity(it.key, it.quantity + 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text('£${(it.price * it.quantity).toStringAsFixed(2)}'),
                                          ],
                                        ),
                                        TextButton(key: ValueKey('remove-${it.key}'), onPressed: () => globalCart.remove(it.key), child: const Text('Remove', style: TextStyle(color: Color(0xFF4d2963)))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Notes section omitted per request (placeholder)
                    const SizedBox(height: 8),

                    // Subtotal and actions
                    LayoutBuilder(builder: (ctx, constraints) {
                      final isMobile = constraints.maxWidth < 700;
                      final subtotal = items.fold<double>(0.0, (p, e) => p + e.price * e.quantity);
                      final subtotalWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Subtotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text('£${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          const Text('Tax included and shipping calculated at checkout', style: TextStyle(color: Colors.black54)),
                        ],
                      );

                      if (!isMobile) {
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Add a note to your order'),
                                  const SizedBox(height: 8),
                                  Container(height: 80, color: Colors.transparent),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 12,
                                    children: [
                                      OutlinedButton(onPressed: _updateQuantities, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14), child: Text('UPDATE'))),
                                      ElevatedButton(key: const ValueKey('checkout'), onPressed: items.isEmpty ? null : _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14), child: Text('CHECK OUT'))),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(padding: const EdgeInsets.only(top: 12), child: subtotalWidget),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 12,
                                    children: [
                                      ElevatedButton(onPressed: _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B2AF7)), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14), child: Text('shop', style: TextStyle(color: Colors.white, fontSize: 16)))),
                                      ElevatedButton(onPressed: _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), child: Text('G Pay', style: TextStyle(color: Colors.white)))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      // mobile layout buttons stacked
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: subtotalWidget),
                          Row(children: [Expanded(child: OutlinedButton(onPressed: _updateQuantities, child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('UPDATE')))), const SizedBox(width: 12), Expanded(child: ElevatedButton(key: const ValueKey('checkout'), onPressed: items.isEmpty ? null : _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)), child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('CHECK OUT'))))]),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B2AF7)), child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('shop', style: TextStyle(color: Colors.white, fontSize: 16)))),
                          const SizedBox(height: 8),
                          ElevatedButton(onPressed: _placeOrderAndNavigate, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('G Pay', style: TextStyle(color: Colors.white)))),
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
