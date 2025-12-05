import 'package:flutter/material.dart';
import 'package:union_shop/models/orders.dart';
import 'package:union_shop/widgets/shared_layout.dart';

String _formatDate(DateTime dt) {
  final d = dt.toLocal();
  final day = d.day.toString().padLeft(2, '0');
  final mon = d.month.toString().padLeft(2, '0');
  final year = d.year;
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '$day/$mon/$year $hh:$mm';
}

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
  final order = globalOrders.orders.firstWhere((o) => o.id == orderId, orElse: () => Order(id: orderId, placedAt: DateTime.now(), items: []));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 72, color: Color(0xFF4d2963)),
                              const SizedBox(height: 12),
                              const Text('Thank you — your order has been placed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text('Placed: ${_formatDate(order.placedAt)}', style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Summary card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Order summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              if (order.items.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('No items recorded for this order.', style: TextStyle(color: Colors.grey[700])),
                                )
                              else
                                SizedBox(
                                  height: 260,
                                  child: ListView.separated(
                                    itemCount: order.items.length,
                                    separatorBuilder: (_, __) => const Divider(height: 12),
                                    itemBuilder: (ctx, i) {
                                      final it = order.items[i];
                                      final lowerId = it.id.toLowerCase();
                                      final lowerTitle = it.title.toLowerCase();
                                      final isMedia = lowerId.contains('cd') || lowerId.contains('vinyl') || lowerTitle.contains('cd') || lowerTitle.contains('vinyl');
                                      final mediaLabel = lowerId.contains('vinyl') || lowerTitle.contains('vinyl') ? 'Vinyl' : (lowerId.contains('cd') || lowerTitle.contains('cd') ? 'CD' : 'Media');
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(it.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                        subtitle: isMedia ? Text('Format: $mediaLabel') : Text('${it.color} • ${it.size}'),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('x${it.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                            Text('£${(it.price * it.quantity).toStringAsFixed(2)}'),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total items: ${order.totalItems}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text('£${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                              icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                              label: const Text('CONTINUE SHOPPING', style: TextStyle(fontWeight: FontWeight.w800)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4d2963),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                minimumSize: const Size(120, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor: Colors.black45,
                                textStyle: const TextStyle(letterSpacing: 0.6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Subtle elevated white button with purple border
                          Expanded(
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(12),
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/account'),
                                icon: const Icon(Icons.account_circle_outlined, size: 20),
                                label: const Text('VIEW ACCOUNT', style: TextStyle(fontWeight: FontWeight.w700)),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF4d2963),
                                  side: const BorderSide(color: Color(0xFF4d2963)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
