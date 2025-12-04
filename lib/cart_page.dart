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
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final items = globalCart.items;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.header,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Text('Your cart', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    if (items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(child: Text('Your cart is empty')),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (ctx, i) {
                          final it = items[i];
                          return ListTile(
                            leading: it.image != null ? Image.network(it.image!, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container(color: Colors.grey[300], width:56,height:56)) : null,
                            title: Text(it.title),
                            subtitle: Text('${it.color} • ${it.size}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  key: ValueKey('dec-${it.key}'),
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => globalCart.updateQuantity(it.key, it.quantity - 1),
                                ),
                                Text('${it.quantity}', key: ValueKey('qty-${it.key}')),
                                IconButton(
                                  key: ValueKey('inc-${it.key}'),
                                  icon: const Icon(Icons.add),
                                  onPressed: () => globalCart.updateQuantity(it.key, it.quantity + 1),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  key: ValueKey('remove-${it.key}'),
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => globalCart.remove(it.key),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items: ${globalCart.totalItems}'),
                        ElevatedButton(
                          key: const ValueKey('checkout'),
                          onPressed: items.isEmpty ? null : _checkout,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                          child: const Text('PLACE ORDER'),
                        ),
                      ],
                    ),
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
