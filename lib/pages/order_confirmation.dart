import 'package:flutter/material.dart';
import 'package:union_shop/models/orders.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
  final order = globalOrders.orders.firstWhere((o) => o.id == orderId, orElse: () => Order(id: orderId, placedAt: DateTime.now(), items: []));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order ID: ${order.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Placed: ${order.placedAt}'),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            if (order.items.isEmpty)
              const Text('No items recorded for this order.')
            else
              Expanded(
                child: ListView.separated(
                  itemCount: order.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (ctx, i) {
                    final it = order.items[i];
                    return ListTile(
                      leading: SizedBox(width: 56, child: Center(child: Text(''))),
                      title: Text(it.title),
                      subtitle: Text('${it.color} • ${it.size}'),
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
            Text('Total items: ${order.totalItems}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Order total: £${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
              child: const Text('CONTINUE SHOPPING'),
            ),
          ],
        ),
      ),
    );
  }
}
